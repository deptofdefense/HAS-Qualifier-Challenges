use std::{thread, time};
pub use byteorder::{BigEndian, ReadBytesExt, WriteBytesExt};
use std::io::{Cursor, Seek, SeekFrom};
use std::collections::HashMap;
pub use spacepacket::SpacePacket;
extern crate sys_info;
use serde_json;

use Config;

pub enum HkCmds {

    ShutdownCommand,
    SleepCommand{interval: u16},
    RawCommand{raw: Vec<u8>},

}


fn send_hk_ps_list(tlm_send: &std::sync::mpsc::Sender<Vec<u8>>, &sequence_number: &u16, &apid: &u16) {

    let mut map = HashMap::new();
    map.insert("query", "{ps {pid,cmd}}");   
    
    let client = reqwest::blocking::Client::new();

    let ps_list = match client.post("http://127.0.0.1:8030/").json(&map).send() {

        Ok(n) => match n.text() {
            Ok(n) => n,
            Err(_e) => {

                let ps_info  = serde_json::json!( { "data": { "processInfo": { "pid": "unknown", "cmd": "unknown" } } });
                let string_version = ps_info.to_string().to_owned();
                string_version

            }
        },
        Err(_e) => serde_json::json!( { "data": { "processInfo": { "pid": "unknown", "cmd": "unknown" } } }).to_string().to_owned(),
    };

    // eprintln!("Housekeeping task results:");
    eprintln!("{:#?}", ps_list);

    let payload = ps_list.as_bytes();

    let sp : SpacePacket = SpacePacket{   apid: apid, 
        sec_hdr_flag: 0, 
        version: 0,
        packet_type: 0,
        seq_flags: 3,
        seq_num: sequence_number,
        data_len: (payload.len() as u16) -1,
        payload: payload.to_vec() };

    let telemetry_data = sp.to_vec();

    let _result = tlm_send.send( telemetry_data );

}

fn send_hk_data( tlm_send: &std::sync::mpsc::Sender<Vec<u8>>, &sequence_number: &u16, &apid: &u16) {



    // send_hk_ps_list( tlm_send, &sequence_number, &apid);


    let mut map = HashMap::new();
    map.insert("query", "{memInfo{total,available,free}}");


    let client = reqwest::blocking::Client::new();

     let memory_stats = match client.post("http://127.0.0.1:8030/").json(&map).send() {

        Ok(n) => match n.text() {

            Ok(n) => n,
            Err(_e) => {

                let json_mem_info  = serde_json::json!( { "data": { "memInfo": { "total": "unknown", "free": "unknown" } } });
                let string_version = json_mem_info.to_string().to_owned();
                string_version

            }
        },
        Err(_e) => {

            let json_mem_info  = serde_json::json!( { "data": { "memInfo": { "total": "unknown", "free": "unknown" } } });
            let string_version = json_mem_info.to_string().to_owned();
            string_version

        },


     };
     
     
    eprintln!("{:#?}", memory_stats);

    let mut payload = memory_stats;

    let disk_info = sys_info::disk_info();

    let (disk_total, disk_free) = match disk_info {

        Ok(n) =>  {
            
            eprintln!("Disk total: {}, Dis free: {}", n.total, n.free);
            (n.total, n.free)
            // payload.write_u64::<BigEndian>(n.total).unwrap();
            // payload.write_u64::<BigEndian>(n.free).unwrap();
        
        },
        Err(_e)=>  {
            eprintln!("Unable to get disk info");
            ( 0, 0)
            // payload.write_u64::<BigEndian>(0).unwrap();
            // payload.write_u64::<BigEndian>(0).unwrap();
            
        },
    };
    

    let json_disk_info  = serde_json::json!( { "data": { "diskInfo": { "total": disk_total, "free": disk_free } } });

    let string_version = json_disk_info.to_string();

    payload.push_str(&string_version);

    eprintln!("{:#?}", payload);

    let payload = payload.as_bytes();


    // let payload = string_version.as_bytes();
    // let mem_info = sys_info::mem_info();

    // let (mem_total, mem_free) = match mem_info {
    //     Ok(n) =>  {
            
            // eprintln!("Mem total: {}, Mem free: {}", n.total, n.free);
    //         payload.write_u64::<BigEndian>(n.total).unwrap();
    //         payload.write_u64::<BigEndian>(n.free).unwrap();
            //  (n.total, n.free)
        
    //     },
    //     Err(_e)=>  {
    //         eprintln!("Unable to get Mem info");
    //         payload.write_u64::<BigEndian>(0).unwrap();
    //         payload.write_u64::<BigEndian>(0).unwrap();
            // (0, 0)
            
    //     },

    // };


    let sp : SpacePacket = SpacePacket{   apid: apid, 
        sec_hdr_flag: 0, 
        version: 0,
        packet_type: 0,
        seq_flags: 3,
        seq_num: sequence_number,
        data_len: (payload.len() as u16) -1,
        payload: payload.to_vec() };


    let telemetry_data = sp.to_vec();

    let _result = tlm_send.send( telemetry_data );

}

pub fn do_housekeeping( service_config: Config, tlm_send: std::sync::mpsc::Sender<Vec<u8>>, cmd_rx: std::sync::mpsc::Receiver<HkCmds>, _response_tx: std::sync::mpsc::Sender<Vec<u8>>) {

    let sleep_interval = time::Duration::from_millis(service_config.housekeeping.wakeup_interval as u64 *1000);

    let mut housekeeping_interval = time::Duration::new(service_config.housekeeping.poll_interval as u64, 0);
   
    let apid = service_config.housekeeping.apid;

    let mut now = time::Instant::now();

    let mut sequence_number:u16 = 0;

    loop {

        thread::sleep(sleep_interval);

        let result = cmd_rx.try_recv();

        match result {

            Ok(n) => { 
                
                // eprintln!("Housekeeping received a new command");

                match n {

                    HkCmds::SleepCommand{interval} => { 

                        eprintln!("now should sleep for {}", interval);
                    
                        housekeeping_interval = time::Duration::from_millis( interval as u64);

                    },
                    HkCmds::ShutdownCommand => {

                        return;
                    }
                    HkCmds::RawCommand{raw: bytes} => {

                        let mut rdr = Cursor::new(bytes);

                        match rdr.seek(SeekFrom::Start(6)) {

                            Ok(_n) => (),
                            Err(_e) => { eprintln!("Bad HK command"); continue; },
                        }

                        let cmd = rdr.read_u8().unwrap();

                        eprintln!("new cmd is {}", cmd);

                        if cmd == 2 {

                            let delay = rdr.read_u16::<BigEndian>().unwrap();

                            eprintln!("New delay value is {}", delay);

                            housekeeping_interval = time::Duration::new( delay as u64, 0);
                        }
                        else if cmd == 101 {

                            send_hk_ps_list( &tlm_send, &sequence_number, &apid);
                            sequence_number += 1;

                        }
                    }
                    
                }
                
            },
            Err(_e) => (),

        };

        if now.elapsed() >= housekeeping_interval {

            eprintln!("Its time to clean house");

            now = time::Instant::now();

            send_hk_data( &tlm_send, &sequence_number, &apid);

            sequence_number += 1;          

        }

    }

}
