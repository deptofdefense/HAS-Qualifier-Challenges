import os
from dataclasses import dataclass
from enum import Enum
from typing import Optional

import yaml

from vax_common.challenge import get_challenge_id
from vax_common.flag import get_flag

CONFIG_PATH = "/assets/config.yml"
ASSETS_DIR = "/assets"


class VaxOs(Enum):
    OPEN_VMS = "open_vms"
    OPEN_BSD = "open_bsd"


@dataclass(frozen=True)
class VaxConfig:
    challenge_id: Optional[int]
    flag: str
    vax_os: VaxOs
    reposition_satellite_command_list: str
    passphrase_list: str
    server_disassembly_list: str
    server_application_list: str
    server_disassembly_dir: str
    server_application_dir: str


def get_config(conifg_path: str = CONFIG_PATH):
    with open(conifg_path) as file_handle:
        config = yaml.full_load(file_handle)
    return VaxConfig(
        get_challenge_id(),
        get_flag(),
        VaxOs(config["vax_os"]),
        os.path.abspath(config["reposition_satellite_command_list"]),
        os.path.abspath(config["passphrase_list"]),
        os.path.abspath(config["server_disassembly_list"]),
        os.path.abspath(config["server_application_list"]),
        os.path.abspath(config["server_disassembly_dir"]),
        os.path.abspath(config["server_application_dir"])
    )
