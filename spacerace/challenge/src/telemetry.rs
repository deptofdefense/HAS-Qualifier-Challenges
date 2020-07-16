use std::{thread, time};
pub use spacepacket::SpacePacket;
pub use byteorder::{BigEndian, ReadBytesExt, WriteBytesExt};
use std::net::{ UdpSocket};
use std::net::{ SocketAddr, Ipv4Addr, TcpStream};
use std::collections::HashMap;
use Config;
use std::io::prelude::*;


pub enum TlmCmds {

    ShutdownCommand,
    DestinationCommand{ addr: TcpStream},
    SleepCommand{interval: u16},
    RawCommand{raw: Vec<u8>},

}


// fn open_socket(address: String) -> Option<UdpSocket> {

//     let  socket = std::net::UdpSocket::bind(address);

//     match socket {

//         Ok(n) => Some(n),
//         Err(_e) => None,
//     }
    
// }


fn check_telemetry_service() -> bool {

    let mut map = HashMap::new();
    map.insert("query", "{ping}");   
    
    let client = reqwest::blocking::Client::new();

    let telemetry_response = match client.post("http://127.0.0.1:8020/").json(&map).send() {

        Ok(n) => match n.text() {
            Ok(n) => n,
            Err(_e) => return false,
        },
        Err(_e) => return false,
    };

    eprintln!("Telemetry service results:");
    eprintln!("{:#?}", telemetry_response);

    if telemetry_response.contains("pong") {

        return true;
    }
    else {

        return false;
    }


}

fn get_eps_data(config: &Config) -> Option<Vec<u8>> {


    if check_telemetry_service() == false {
        eprintln!("Telemetry service is not running");
        return None;
    }

    let bind_str = config.flag.ip.clone();

    let eps_address_v4: Ipv4Addr = bind_str.parse().unwrap();

    let socket = match eps_address_v4.is_loopback() {

        true => match UdpSocket::bind("127.0.0.1:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return None
            },
        },
        false => match UdpSocket::bind("0.0.0.0:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for flag data");
                        return None
            },
        },

    };

    let duration = std::time::Duration::new(4, 0);

    let _res = socket.set_read_timeout(Some(duration));

    let cmd = String::from("TELEMETRY");

    let addr = SocketAddr::from((eps_address_v4, 6667));

    match socket.send_to(cmd.as_bytes(), &addr) {

        Ok(_n) => (),
        Err(_e) => return None,
    }

    let mut buf = [0; 1024];

    match socket.recv(&mut buf) {

        Ok(_n) => Some(buf.to_vec()),
        Err(_e) => None,
    }

}

fn save_eps_to_db(_config: &Config, data: Vec<u8>)  {


    let mut_string = format!("{{\"query\":\"mutation {{insert(subsystem:\\\"eps\\\",parameter:\\\"current\\\",value:\\\"{}\\\"){{success}}}}\"}}", data[0]);
   
    let client = reqwest::blocking::Client::new();

    let telemetry_response = match client.post("http://127.0.0.1:8020/").body(mut_string).send() {

        Ok(n) => match n.text() {
            Ok(n) => n,
            Err(_e) => return ,
        },
        Err(_e) => return ,
    };

    eprintln!("{:#?}", telemetry_response);


}


pub fn do_telemetry( service_config: Config, tlm2send: std::sync::mpsc::Receiver<Vec<u8>>, cmds: std::sync::mpsc::Receiver<TlmCmds>, _responses: std::sync::mpsc::Sender<TlmCmds>) {


    const SLEEP_INTERVAL: time::Duration = time::Duration::from_millis(1000);

    let mut telemetry_interval = time::Duration::new(5, 0);

    // let socket = open_socket(String::from("0.0.0.0:34343")).expect("Unable to initially open socket");

    let mut dest_host = None;

    // let remote_host = String::with_capacity(128);

    let mut now = time::Instant::now();

    // let done = false;

    loop {

        thread::sleep(SLEEP_INTERVAL);
        // eprintln!("TLM woke up from sleep");

        let result = cmds.try_recv();

        match result {

            Ok(n) => { 
                
                // eprintln!("Received a new command");

                match n {

                    TlmCmds::SleepCommand{interval} => { 

                        eprintln!("now should sleep for {}", interval);
                    
                        telemetry_interval = time::Duration::from_millis( interval as u64);

                    },
                    TlmCmds::DestinationCommand{addr} => {
                        
                        eprintln!("set destination command");

                        dest_host = Some(addr);  // addr.to_socket_addrs().unwrap().next();

                    },
                    TlmCmds::ShutdownCommand => {

                        eprintln!("Time to shutdown this TLM thread");
                        return;
                    },
                    TlmCmds::RawCommand{raw: _bytes} => {

                        eprintln!("Got a raw command to execute");

                    },
                }
                
            },
            Err(_e) => (),

        };

        if now.elapsed() >= telemetry_interval {

            eprintln!("Its time to collect and send telemetry");

            // get_eps_data(&service_config);

            match get_eps_data(&service_config) {

                Some(n) => save_eps_to_db(&service_config, n),
                None => (),
            };


            loop {
                let telemetry_data = tlm2send.try_recv();

                match telemetry_data {

                    Ok(n) => {

                        match &dest_host {

                            Some(x) => { let socket = x.try_clone();
                                
                                match socket.unwrap().write(&n) {

                                    Ok(_n) => (),
                                    Err(_e) => { eprintln!("Error writing to socket"); dest_host = None},
                                };
                                
                            },

                            None => {eprintln!("destination is not set"); },
                        };

                    },
                    Err(_e) => break,
                };

                now = time::Instant::now();
            }
        }

    }


}
