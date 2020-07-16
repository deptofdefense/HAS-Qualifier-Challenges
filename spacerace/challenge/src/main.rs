use std::net::{TcpListener};
use std::{thread};
use std::sync::mpsc::channel;
use std::env;

extern crate byteorder;
extern crate toml;
extern crate serde_derive;
extern crate serde_json;
extern crate crc;

mod housekeeping;
mod payload;
mod flag;
mod telemetry;
mod config;
use config::Config as Config;
mod spacepacket;
use crate::spacepacket::SpacePacket;


fn handle_command_one(_tx: std::sync::mpsc::Sender<telemetry::TlmCmds>, packet: spacepacket::SpacePacket) {


    let _destination = String::from_utf8_lossy( &packet.payload[1..]);

    // eprintln!("destination: {}", destination);
    // let _result = tx.send( telemetry::TlmCmds::DestinationCommand{ addr: destination.to_string()});

}

fn handle_command_two(tx: std::sync::mpsc::Sender<housekeeping::HkCmds>, _packet: SpacePacket) {


    let _result = tx.send(housekeeping::HkCmds::SleepCommand{interval: 30});
}

fn handle_command_three(tx: std::sync::mpsc::Sender<payload::PayloadCmds>, _packet: spacepacket::SpacePacket) {

    let _result = tx.send(payload::PayloadCmds::SleepCommand{interval: 30});
}

fn handle_command_four(tx: std::sync::mpsc::Sender<telemetry::TlmCmds>, _packet: spacepacket::SpacePacket) {

    let _result = tx.send( telemetry::TlmCmds::ShutdownCommand);
}

fn handle_command_five(tx: std::sync::mpsc::Sender<telemetry::TlmCmds>, _packet: spacepacket::SpacePacket) {

    let _result = tx.send( telemetry::TlmCmds::SleepCommand{interval: 30});

}

fn handle_command_six(tx: std::sync::mpsc::Sender<flag::FlagCmds>, _packet: spacepacket::SpacePacket) {

    let _result = tx.send( flag::FlagCmds::SleepCommand{interval: 30});

}

// gently shutdown the app by telling all the threads to end
fn shutdown_app( hk_send: std::sync::mpsc::Sender<housekeeping::HkCmds>, 
                    pl_send: std::sync::mpsc::Sender<payload::PayloadCmds>, 
                    flag_send: std::sync::mpsc::Sender<flag::FlagCmds>, 
                    tlm_send: std::sync::mpsc::Sender<telemetry::TlmCmds> ) {


    let _result = hk_send.send( housekeeping::HkCmds::ShutdownCommand);
    let _result = pl_send.send( payload::PayloadCmds::ShutdownCommand);
    let _result = flag_send.send( flag::FlagCmds::ShutdownCommand);
    let _result = tlm_send.send( telemetry::TlmCmds::ShutdownCommand);

}

// simple timeout thread that will forcefully terminate the app when it expires
fn do_timeout( timeout: u32 ) {

    std::thread::sleep(std::time::Duration::new(timeout as u64,0));
    eprintln!("Its time to die");
    std::process::exit(0);

}


fn process_commands(config: Config, hkrx: std::sync::mpsc::Sender<housekeeping::HkCmds>, tlmrx: std::sync::mpsc::Sender<telemetry::TlmCmds>, 
        plrx: std::sync::mpsc::Sender<payload::PayloadCmds> , flagrx: std::sync::mpsc::Sender<flag::FlagCmds> ) {


    let key = "SERVICE_HOST";

    let host = match env::var_os(key) {
        Some(val) => val.into_string().unwrap(),
        None => String::from("0.0.0.0"),
    };

    let key = "SERVICE_PORT";

    let port = match env::var_os(key) {
        Some(val) => val.into_string().unwrap(),
        None => String::from("4321"),
    };

    // tell the competitor where the docker container will be listening
    let bind_str = format!("{}:{}", host, port);

    // but the service will be listening inside on port 5063
    let listener = TcpListener::bind("0.0.0.0:5063").expect("couldn't listen on that port");

    let hk_apid = config.housekeeping.apid;
    let pl_apid = config.payload.apid;
    let tlm_apid = config.telemetry.apid;
    let flag_apid = config.flag.apid;

    println!("Connect to = {}", bind_str);

    loop {


        let  (mut stream, _addr) = listener.accept().expect("an error with the accept call");

        let _result = tlmrx.send( telemetry::TlmCmds::DestinationCommand{ addr: stream.try_clone().unwrap()});


        loop {

            let sp = match spacepacket::read_space_packet(&mut stream) {

                Ok(n) => n,
                Err(_e) => break,
            };

            if sp.version != 0 {

                eprintln!("Bad space packet version");
                continue;
            }

            let bytes = sp.to_vec();

            if sp.apid == hk_apid {

                eprintln!("got a task for housekeeping apid: {}", hk_apid);
                let _result = hkrx.send(housekeeping::HkCmds::RawCommand{raw: bytes});

            }
            else if sp.apid == pl_apid {

                eprintln!("got a task for payload {}", pl_apid);
                let _result = plrx.send(payload::PayloadCmds::RawCommand{raw: bytes});

            }
            else if sp.apid == tlm_apid {

                eprintln!("got a task for the tlm");
                let _result = tlmrx.send(telemetry::TlmCmds::RawCommand{raw: bytes});

            }
            else if sp.apid == flag_apid {

                eprintln!("got a task for the flag");
                let _result = flagrx.send(flag::FlagCmds::RawCommand{raw: bytes});

            }
            else if sp.apid == 7 {
                match sp.payload[0] {

                    0 => handle_command_one( tlmrx.clone(), sp ),
                    1 => handle_command_two( hkrx.clone(), sp ),
                    2 => handle_command_three( plrx.clone(), sp ),
                    3 => handle_command_four( tlmrx.clone(), sp ),
                    4 => { 
                            shutdown_app( hkrx, plrx, flagrx, tlmrx);
                            return;
                    },
                    5 => handle_command_five( tlmrx.clone(), sp),
                    6 => handle_command_six( flagrx.clone(), sp),
                    _ => handle_command_four( tlmrx.clone(), sp),
                }


            }
            else {

                eprintln!("Bad APID ignored");
            }

        }
    }
}


fn main()  {


    let config = match config::load_config() {

        Some(n) => n,
        None => return,
    };

    // config.save_config();
    let key = "TIMEOUT";

    let timeout_str = match env::var_os(key) {
        Some(val) => val.into_string().unwrap(),
        None => String::from("180"),
    };

    let timeout = timeout_str.parse::<u32>().unwrap();


    // eprintln!("Timeout = {}", timeout);

    let _timeout_handle = thread::spawn(move || {
        do_timeout(timeout);

    });


    let (sendtlmtx, sendtlmrx) = channel();
    let (to_tlmtx, to_tlmrx) = channel();
    let (from_tlmtx, _from_tlmrx) = channel();

    let tlm_config = config.clone();

    let tlm_handle = thread::spawn(move || {

        telemetry::do_telemetry(tlm_config, sendtlmrx, to_tlmrx, from_tlmtx);

    });

    // setup a pair of channels for the housekeeping thread and start that thread
    let (to_hktx, to_hkrx) = channel();
    let (from_hktx, _fromhkrx) = channel();

    let tlmsend = sendtlmtx.clone();

    let hk_config = config.clone();

    let hk_handle = thread::spawn(move || {
        housekeeping::do_housekeeping(hk_config, tlmsend, to_hkrx, from_hktx);

    });



    let (to_pltx, to_plrx) = channel();
    let (from_pltx, _from_plrx) = channel();


    let tlmsend = sendtlmtx.clone();
    let pl_config = config.clone();

    let pl_handle = thread::spawn(move || {
        payload::do_payload(pl_config, tlmsend, to_plrx, from_pltx);

    });

    let (to_flagtx, to_flagrx) = channel();
    let (from_flagtx, _from_flagrx) = channel();


    let tlmsend = sendtlmtx.clone();
    let pl_config = config.clone();

    let flag_handle = thread::spawn(move || {
        flag::do_flag(pl_config, tlmsend, to_flagrx, from_flagtx);

    });

    // let startup_delay_interval = time::Duration::from_millis(2000);
    // thread::sleep(startup_delay_interval);

    // do_query();

    process_commands( config, to_hktx, to_tlmtx, to_pltx, to_flagtx) ;

    tlm_handle.join().unwrap();
    pl_handle.join().unwrap();
    flag_handle.join().unwrap();
    hk_handle.join().unwrap();


}

