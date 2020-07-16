use std::{thread, time};
pub use spacepacket::SpacePacket;
pub use byteorder::{BigEndian, ReadBytesExt, WriteBytesExt};
use std::net::{ UdpSocket};
use std::net::{ SocketAddr, Ipv4Addr};
use std::sync::{Arc, Mutex};
use std::process::{Command};
use Config;


pub enum FlagCmds {

    ShutdownCommand,
    SleepCommand{interval: u16},
    RawCommand{raw: Vec<u8>},

}

#[derive(Clone)]
struct AppState {

    running: bool,
    tlm_channel: std::sync::mpsc::Sender<Vec<u8>>,
    sequence_number: u16,
    apid: u16,
    status_period: u16,

}


fn check_auth( config: &Config, auth_key: String ) -> bool {


    if auth_key == config.flag.auth_key {

        return true;
    }

    return false;

}

fn send_space_packet( status: &Arc<Mutex<AppState>>, payload : Vec<u8>) {


    let mut status = status.lock().unwrap();

    let apid = status.apid;
    let sequence_number = status.sequence_number;

    let sp : SpacePacket = SpacePacket{   apid: apid, 
        sec_hdr_flag: 0, 
        version: 0,
        packet_type: 0,
        seq_flags: 3,
        seq_num: sequence_number,
        data_len: (payload.len() as u16) -1,
        payload: payload };

    let telemetry_data = sp.to_vec();

    let _result = status.tlm_channel.send( telemetry_data );
    status.sequence_number += 1;

}


fn do_flag_cmd( status: &Arc<Mutex<AppState>>, config: &Config, command: Vec<u8> ) {


    if command.len() < 7 {

        return;
    }

    let mut payload = vec![0;1];

    match command[6] {

        0 => {
            eprintln!("Startup the Flag app");

            let auth_key = String::from_utf8_lossy(&command[7..]).to_string();

            if check_auth( &config, auth_key) == true {

                startup_flag_app(status, &config);
                payload = "OK".as_bytes().to_vec();
            }
            else {

                payload = "NOT AUTHORIZED".as_bytes().to_vec();
            }
        },
        1 => {
            eprintln!("Shutdown the Flag app");

            let auth_key = String::from_utf8_lossy(&command[7..]).to_string();

            if check_auth( &config, auth_key) == true {

                shutdown_flag_app(status, &config);
                payload = "OK".as_bytes().to_vec();

            }
            else {

                payload = "NOT AUTHORIZED".as_bytes().to_vec();
            }
        },
        2 => {

            eprintln!("Retrieve the Flag data");
            payload = get_flag_value( status, &config );

        },
        3 => {

            eprintln!("Set status interval");
            let new_interval: u16 = (command[7] as u16)  << 8 | command[8] as u16;

            eprintln!("New interval value = {}", new_interval);

            if new_interval > 3600 {

                payload = "INVALID INTERVAL".as_bytes().to_vec();
            }
            else {

                status.lock().unwrap().status_period = new_interval;
                payload = "INTERVAL SET".as_bytes().to_vec();
            }

        }
        _ => (),
    }


    send_space_packet(status, payload);


}

// send a shutdown command to the flag app
fn shutdown_flag_app ( status: &Arc<Mutex<AppState>>, config: &Config) {


    let bind_str = config.flag.ip.clone();

    let flag_address_v4: Ipv4Addr = bind_str.parse().unwrap();

    let socket = match flag_address_v4.is_loopback() {

        true => match UdpSocket::bind("127.0.0.1:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return
            },
        },
        false => match UdpSocket::bind("0.0.0.0:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return
            },
        },

    };

    let cmd = String::from("SHUTDOWN");

    let addr = SocketAddr::from((flag_address_v4, config.flag.port));

    match socket.send_to(cmd.as_bytes(), &addr) {

        Ok(_n) => (),
        Err(_e) => return,
    }

    status.lock().unwrap().running = false;

}


fn startup_flag_app ( status: &Arc<Mutex<AppState>>, _config: &Config) -> std::process::Child {


    let flag_app = Command::new("./flagApp.py").spawn().expect("Failed to start flag process");

    status.lock().unwrap().running = true;

    flag_app
}


fn get_flag_value( status: &Arc<Mutex<AppState>>, config: &Config )  -> Vec<u8> {

    let running = status.lock().unwrap().running;

    if running == false {

        eprintln!("flag process isn't running, so can't get the flag");
        let response = "FLAG SERVICE NOT AVAILABLE".as_bytes().to_vec();
        return response

    }

    let bind_str = config.flag.ip.clone();

    let flag_address_v4: Ipv4Addr = bind_str.parse().unwrap();

    let socket = match flag_address_v4.is_loopback() {

        true => match UdpSocket::bind("127.0.0.1:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return "NETWORK ERROR".as_bytes().to_vec();
            },
        },
        false => match UdpSocket::bind("0.0.0.0:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return "NETWORK ERROR".as_bytes().to_vec();
            },
        },

    };

    let duration = std::time::Duration::new(4, 0);

    let _res = socket.set_read_timeout(Some(duration));

    let mut buf = [0; 1024];

    let cmd = String::from("FLAG");

    let addr = SocketAddr::from((flag_address_v4, config.flag.port));

    match socket.send_to(cmd.as_bytes(), &addr) {

        Ok(_n) => (),
        Err(_e) => {
            let response = "FLAG SERVICE NOT RESPONDING".as_bytes().to_vec();
            return response;
        }
    }

    let (amt, _src) = match socket.recv_from(&mut buf) {

        Ok(n) => n,
        Err(_e) => { let response = "FLAG SERVICE NOT RESPONDING".as_bytes().to_vec();
                    return response;
                },
    };

    let mut value = buf.to_vec();

    value.resize_with(amt, Default::default);

    return value;

}




fn get_flag_status( status:  Arc<Mutex<AppState>>, config: Config )  {


    let bind_str = config.flag.ip.clone();

    let flag_address_v4: Ipv4Addr = bind_str.parse().unwrap();

    let mut should_shutdown_process: bool = false;

    let mut child = None;

    let socket = match flag_address_v4.is_loopback() {

        true => match UdpSocket::bind("127.0.0.1:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return;
                    },
        },
        false => match UdpSocket::bind("0.0.0.0:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return;
                    },
        },

    };


    let duration = std::time::Duration::new(4, 0);

    let _res = socket.set_read_timeout(Some(duration));


    // Receives a single datagram message on the socket. If `buf` is too small to hold
    // the message, it will be cut off.

    if status.lock().unwrap().running == false {

        eprintln!("flag process isn't running, so starting it up");

        should_shutdown_process = true;

        child = Some(startup_flag_app(&status, &config));

        // wait one second for the process to be ready to receive our request
        let startup_delay_interval = time::Duration::from_millis(1000);
        thread::sleep(startup_delay_interval);
    }

    let mut buf = [0; 1024];

    let cmd = String::from("STATUS");

    let addr = SocketAddr::from((flag_address_v4, config.flag.port));

    match socket.send_to(cmd.as_bytes(), &addr) {

        Ok(_n) => (),
        Err(_e) => return,
    }

    let (amt, _src) = match socket.recv_from(&mut buf) {

        Ok(n) => n,
        Err(_e) => return,
    };

    let mut value = buf.to_vec();

    value.resize_with(amt, Default::default);

    send_space_packet( &status, value);

    if should_shutdown_process == true {

        eprintln!("Shutting flag process back down");
        shutdown_flag_app(&status, &config);

        match child {

            Some(ref mut n) => {
                
                let _result = n.wait();
            },
            None => (),
        };

    }
    else {

        eprintln!("Don't need to shut it back down");
    }

}


pub fn do_flag( service_config: Config, tlm_send: std::sync::mpsc::Sender<Vec<u8>>, cmd_rx: std::sync::mpsc::Receiver<FlagCmds>, _response_tx: std::sync::mpsc::Sender<FlagCmds>) {

    let sleep_interval = time::Duration::from_millis(service_config.flag.wakeup_interval as u64 *1000);

    // let mut polling_interval = time::Duration::new(service_config.flag.poll_interval as u64, 0);
    let mut polling_interval : time::Duration;

    let mut now = time::Instant::now();

    let status = Arc::new(Mutex::new(AppState{  running: false,
                                // locked: false,
                                tlm_channel: tlm_send.clone(),
                                sequence_number: 1,
                                apid: service_config.flag.apid,
                                status_period: service_config.flag.poll_interval,
                            }));

    loop {

        thread::sleep(sleep_interval);
        {
            let value = &status.lock().unwrap().status_period;

            polling_interval = time::Duration::new(*value as u64, 0);
        }

        let result = cmd_rx.try_recv();

        match result {

            Ok(n) => { 
                
                match n {

                    FlagCmds::SleepCommand{interval} => { 

                        eprintln!("now should sleep for {}", interval);
                    
                        polling_interval = time::Duration::from_millis( interval as u64);

                    },
                    FlagCmds::ShutdownCommand => {

                        if status.lock().unwrap().running == true {

                            shutdown_flag_app(&status, &service_config);
                        }
                        return;
                    }
                    FlagCmds::RawCommand{raw} => {

                        do_flag_cmd( &status, &service_config.clone(), raw);

                    },
                }
                
            },
            Err(_e) => (),

        };

        if now.elapsed() >= polling_interval {

            eprintln!("Its time to poll the flag app");

            {
                let status = status.clone();
                let the_config = service_config.clone();

                let _handle = thread::spawn(move || {

                    get_flag_status(status, the_config);

                });

            }
            now = time::Instant::now();

        }

    }

}


