
use std::{thread, time};
pub use spacepacket::SpacePacket;
pub use byteorder::{BigEndian, ReadBytesExt, WriteBytesExt};
use Config;
use std::net::{ UdpSocket};
use std::net::{ SocketAddr, Ipv4Addr};

pub enum PayloadCmds {

    ShutdownCommand,
    SleepCommand{interval: u16},
    RawCommand{raw: Vec<u8>},

}

enum PayloadState {

    Initialized,
    Reset,
    Nominal,
    Stopped,
}

struct PayloadStatus {

    state : PayloadState,
    key : u64,
    socket: std::net::UdpSocket,
    poll_interval: std::time::Duration,
    sequence_number: u16,
    apid: u16,
}

fn init_payload(service_config: &Config) -> Option<PayloadStatus> {

    let bind_str = service_config.payload.ip.clone();

    let payload_address_v4: Ipv4Addr = bind_str.parse().unwrap();

    let udpsocket = match payload_address_v4.is_loopback() {

        true => match UdpSocket::bind("127.0.0.1:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for payload data");
                        return None
            },
        },
        false => match UdpSocket::bind("0.0.0.0:0") {

            Ok(n) => n,
            Err(_e) => { eprintln!("Unable to bind socket for payload data");
                        return None
            },
        },

    };

    let bind_str = service_config.payload.ip.clone();

    let payload_address_v4: Ipv4Addr = bind_str.parse().unwrap();

    let addr = SocketAddr::from((payload_address_v4, service_config.payload.port));

    let _result = match udpsocket.connect(addr) {

        Ok(_n) => (),
        Err(_e) => return None,
    };

    let key = 0x1234 as u64;

    let state = PayloadState::Initialized;

    let polling_interval = time::Duration::new(service_config.payload.poll_interval as u64, 0);

    Some(PayloadStatus { poll_interval: polling_interval, state: state, key: key, socket: udpsocket, sequence_number: 0, apid: service_config.payload.apid})


}

fn get_payload_data( status: &PayloadStatus, _config: Config ) -> Option<Vec<u8>> {


    let duration = std::time::Duration::new(4, 0);

    let _res = status.socket.set_read_timeout(Some(duration));

    let mut response = [0; 1024];

    let mut buffer = vec![];

    let mut cmd = String::from("STATUS").as_bytes().to_vec();

    buffer.append(&mut cmd);

    // wtr.write_u16::<LittleEndian>(517).unwrap();

    buffer.write_u64::<BigEndian>(status.key).unwrap();


    // let addr = SocketAddr::from((payload_address_v4, config.payload.port));

    match status.socket.send(&buffer) {

        Ok(_n) => (),
        Err(_e) => return None,
    }

    let (amt, _src) = match status.socket.recv_from(&mut response) {

        Ok(n) => n,
        Err(_e) => return None,
    };

    let mut value = response.to_vec();

    value.resize_with(amt, Default::default);

    Some(value)
}


fn dump_payload_data( status: &PayloadStatus, _config: Config ) -> Option<Vec<u8>> {


    let duration = std::time::Duration::new(4, 0);

    let _res = status.socket.set_read_timeout(Some(duration));

    let mut buf = [0; 1024];

    let cmd = String::from("DUMP");

    // let addr = SocketAddr::from((payload_address_v4, config.payload.port));

    match status.socket.send(cmd.as_bytes()) {

        Ok(_n) => (),
        Err(_e) => return None,
    }

    let (amt, _src) = match status.socket.recv_from(&mut buf) {

        Ok(n) => n,
        Err(_e) => return None,
    };

    let mut value = buf.to_vec();

    value.resize_with(amt, Default::default);

    Some(value)
}


fn send_to_telemetry( status: &mut PayloadStatus, tlm_send: std::sync::mpsc::Sender<Vec<u8>>, payload: Vec<u8> ) {


    eprintln!("Payload length = {}", payload.len());

    let sp : SpacePacket = SpacePacket{   apid: status.apid, 
        sec_hdr_flag: 0, 
        version: 0,
        packet_type: 0,
        seq_flags: 3,
        seq_num: status.sequence_number,
        data_len: (payload.len() as u16) -1,
        payload: payload };

    let telemetry_data = sp.to_vec();

    status.sequence_number += 1;

    let _result = tlm_send.send( telemetry_data );


}


pub fn do_payload( service_config: Config, tlm_send: std::sync::mpsc::Sender<Vec<u8>>, cmd_rx: std::sync::mpsc::Receiver<PayloadCmds>, _response_tx: std::sync::mpsc::Sender<PayloadCmds>) {

    let sleep_interval = time::Duration::from_millis(service_config.payload.wakeup_interval as u64 *1000);

    let mut payload_status = init_payload( &service_config ).unwrap();

    // let mut polling_interval = time::Duration::new(service_config.payload.poll_interval as u64, 0);

    let mut now = time::Instant::now();

    // let mut sequence_number = 0;
    // let apid = service_config.payload.apid;

    loop {

        thread::sleep(sleep_interval);
        // eprintln!("woke up from sleep");

        let result = cmd_rx.try_recv();

        match result {

            Ok(n) => { 
                
                // eprintln!("Received a new command");

                match n {

                    PayloadCmds::SleepCommand{interval} => { 

                        // eprintln!("now should sleep for {}", interval);
                    
                        payload_status.poll_interval = time::Duration::from_millis( interval as u64);

                    },
                    PayloadCmds::ShutdownCommand => {

                        return;
                    },
                    PayloadCmds::RawCommand{ raw } => {


                        match raw[0] {

                            1 => { 
                                

                                let res = get_payload_data(&payload_status, service_config.clone());

                                let payload = match res {
                    
                                    Some(n) => n,
                                    None => continue,
                                };
                    
                                send_to_telemetry( &mut payload_status, tlm_send.clone(), payload);

                            },
                            2 => { 
                                

                                let res = dump_payload_data(&payload_status, service_config.clone());

                                let payload = match res {
                    
                                    Some(n) => n,
                                    None => continue,
                                };
                    
                                send_to_telemetry( &mut payload_status, tlm_send.clone(), payload);
                                
                            },
                            3 => {

                                payload_status.state = PayloadState::Reset;

                            },
                            _ => payload_status.state = PayloadState::Stopped,
                        }
                    },
                }
                
            },
            Err(_e) => (),

        };

        if now.elapsed() >= payload_status.poll_interval {

            eprintln!("Its time to send payload data");

            let res = get_payload_data(&payload_status, service_config.clone());

            let payload = match res {

                Some(n) => { payload_status.state = PayloadState::Nominal;
                     n
                    },
                None =>  continue,
            };


            send_to_telemetry( &mut payload_status, tlm_send.clone(), payload);

            now = time::Instant::now();

        }

    }

}


