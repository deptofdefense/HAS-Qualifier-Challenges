
use serde_derive::Deserialize;
use serde_derive::Serialize;
use std::fs;
extern crate toml;


#[derive(Deserialize, Serialize, Clone)]
pub struct Config {
    pub command: CommandConfig,
    pub payload: PayloadConfig,
    pub flag: FlagConfig,
    pub telemetry: TelemetryConfig,
    pub housekeeping: HousekeepingConfig,
}

#[derive(Deserialize, Serialize, Clone)]
pub struct CommandConfig {
    pub cmd_port: u16,
    pub apid: u16,
}

#[derive(Deserialize, Serialize, Clone)]
pub struct PayloadConfig {
    pub ip: String,
    pub port: u16,
    pub wakeup_interval: u16,
    pub poll_interval: u16,
    pub apid: u16,
}

#[derive(Deserialize, Serialize, Clone)]
pub struct FlagConfig {
    pub ip: String,
    pub port: u16,
    pub apid: u16,
    pub wakeup_interval: u16,
    pub poll_interval: u16,
    pub auth_key: String,
}

#[derive(Deserialize, Serialize, Clone)]
pub struct TelemetryConfig {
    pub ip: String,
    pub port: u16,
    pub apid: u16,
    pub wakeup_interval: u16,
    pub poll_interval: u16,
}

#[derive(Deserialize, Serialize, Clone)]
pub struct HousekeepingConfig {
    pub wakeup_interval: u16,
    pub poll_interval: u16,
    pub apid: u16,
}



const CONFIG_FILE_NAME: &'static str = "comms-service.toml";

impl Config {

    // pub fn save_config(&self) {
    //     let serialized = toml::to_string(&self).unwrap();

    //     // eprintln!("{}", serialized);

    //     let _result = fs::write(CONFIG_FILE_NAME, serialized);

    // }



}
pub fn load_config() -> Option<Config> {
    let config_bytes = fs::read(CONFIG_FILE_NAME).expect("Could not read config file");

    let config_string = String::from_utf8_lossy(&config_bytes);
    
    let config: Config = toml::from_str(&config_string).expect("Could not parse config data");
    
    return Some(config);
}



