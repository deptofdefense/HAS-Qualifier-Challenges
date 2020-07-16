import os
from dataclasses import dataclass

import yaml

from vax_common.vax_config import VaxConfig, get_config, CONFIG_PATH


@dataclass(frozen=True)
class VaxSolverConfig(VaxConfig):
    server_application_md5_list: str


def get_vax_solver_config(config_path: str = CONFIG_PATH) -> VaxSolverConfig:
    with open(config_path) as file_handle:
        config = yaml.full_load(file_handle)
    vax_config = get_config(config_path)
    return VaxSolverConfig(
        None,
        vax_config.flag,
        vax_config.vax_os,
        vax_config.reposition_satellite_command_list,
        vax_config.passphrase_list,
        vax_config.server_disassembly_list,
        vax_config.server_application_list,
        vax_config.server_disassembly_dir,
        vax_config.server_application_dir,
        os.path.abspath(config["server_application_md5_list"])
    )
