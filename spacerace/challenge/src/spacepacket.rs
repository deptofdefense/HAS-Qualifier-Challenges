// use std::net::{TcpListener, TcpStream, UdpSocket};
use std::io::{Read};
use crc::{crc32, Hasher32};

#[derive(Debug)]
pub struct SpacePacket {

    pub version: u8,
    pub packet_type: u8,
    pub sec_hdr_flag: u8,
    pub apid: u16,
    pub seq_flags: u8,
    pub seq_num: u16,
    pub data_len: u16,
    pub payload: Vec<u8>,
}

// pub fn print_space_packet(sp: &mut SpacePacket) {

//     eprintln!("{:?}", sp);

// }

impl SpacePacket {


    pub fn to_vec(self: &Self) -> Vec<u8> {

        let full_payload_len: u16 = self.payload.len() as u16 -1 +4;

        let mut pickle = Vec::with_capacity(6 + full_payload_len as usize  +1);

        eprintln!("length of payload is {}", self.data_len);

        pickle.push(self.version << 5 | self.packet_type & 1 << 4 | self.sec_hdr_flag & 1 << 3 | (self.apid >> 8) as u8 & 0x7);
        pickle.push((self.apid & 0xff) as u8);

        pickle.push(self.seq_flags << 6 | (self.seq_num >> 8) as u8);
        pickle.push((self.seq_num & 0xff) as u8);

        pickle.push((full_payload_len  >> 8) as u8);
        pickle.push((full_payload_len & 0xff)  as u8);

        pickle.extend(self.payload.iter().cloned());


        let mut digest = crc32::Digest::new(crc32::IEEE);

        digest.write(&pickle);

        let crc = digest.sum32();

        pickle.push((crc >> 24) as u8);
        pickle.push( (crc >> 16 & 0xff) as u8);
        pickle.push( (crc >> 8 & 0xff) as u8);
        pickle.push( (crc & 0xff ) as u8);

        eprintln!("length of vector is {}", pickle.len());

        // eprintln!("{:x}", digest.sum32());

        pickle
    }


}

pub fn read_space_packet(stream: & mut std::net::TcpStream) -> Result<SpacePacket, &'static str> {


    let mut buffer = vec![0; 6 as usize]; //Vec::with_capacity(6); //  [0; 6];
    let mut total_read: usize = 0;
    let mut done = false;

    let mut digest = crc32::Digest::new(crc32::IEEE);

    while done == false {

        let count = stream.read(&mut buffer[total_read..]).unwrap();

        // eprintln!("read {:?} bytes", count);
        total_read += count;
        // eprintln!("total_read = {}", total_read);

        if count == 0 {

            // eprintln!("EOF for stdin");
            return Err("unexpected EOF")
        }

        if total_read == 6 {

            // eprintln!("got enough bytes for the header");
            done = true;
        }
        // else {

        //     eprintln!("total_read = {}", total_read);
        // }

    }

    digest.write(&buffer);

    let version = buffer[0] >> 5;
    let packet_type = buffer[0] >> 4 & 0x1;
    let sec_hdr_flag = buffer[0] >> 3 & 0x1;

    let apid: u16 = (buffer[0] as u16 & 3 << 8 )| u16::from( buffer[1]);

    let seq_flags = buffer[2] >> 6;

    let seq_num: u16 = ((u16::from(buffer[2]) & 64) << 8) | u16::from(buffer[3]);

    let data_len: u16 = (u16::from(buffer[4]) << 8 | u16::from(buffer[5])) +1;

    // eprintln!("data_len = {}", data_len);

    if data_len < 5 {
        return Err("Invalid payload length");
    }

    let mut payload = vec![0; data_len as usize];

    total_read = 0;

    done = false;

    while !done {

        // let count = io::stdin().read(&mut payload[total_read..]).unwrap();
        let count = stream.read(&mut payload[total_read..]).unwrap();

        // eprintln!("read {:?} bytes", count);
        total_read += count;

        if count == 0 {

            // eprintln!("EOF for stdin");
            return Err("unexpected EOF")
        }

        if total_read == data_len as usize {

            // eprintln!("got all the payload");
            done = true;
        }
        // else {

        //     eprintln!("total_read = {}", total_read);
        // }
    }

    let len = payload.len();

    let mut pkt_crc = payload[len-4] as u32;

    pkt_crc = pkt_crc << 8 | payload[len-3] as u32;
    pkt_crc = pkt_crc << 8 | payload[len-2] as u32;
    pkt_crc = pkt_crc << 8 | payload[len-1] as u32;

    digest.write(&payload[0..len-4]);

    let crc = digest.sum32();

    payload.drain(len-4..len);

    // eprintln!("{:x}",crc );
    // eprintln!("sent: {:x}", pkt_crc);

    if crc != pkt_crc {

        return Err("bad CRC on packet")
    }

    let alpha :SpacePacket = SpacePacket{   apid: apid, 
                                                sec_hdr_flag: sec_hdr_flag, 
                                                version: version,
                                                packet_type: packet_type,
                                                seq_flags: seq_flags,
                                                seq_num: seq_num,
                                                data_len: data_len,
                                                payload: payload };

    Ok(alpha)
}
