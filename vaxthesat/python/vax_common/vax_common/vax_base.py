import json
import logging
import os

from vax_common.constant import SERVER_MAR, SERVER_EXE, SERVER, SERVER_S
from vax_common.random_seed import get_random_seed
from vax_common.vax_config import VaxConfig, VaxOs

LOGGER = logging.getLogger(__name__)


class VaxBase:
    def __init__(
            self,
            vax_config: VaxConfig
    ):
        self._config = vax_config
        LOGGER.debug("Random seed: %i", get_random_seed())
        LOGGER.debug("Challenge id: %i", self._config.challenge_id)
        LOGGER.debug("Flag: %s", self._config.flag)

    def _get_passphrase(self) -> str:
        with open(self._config.passphrase_list) as file_handle:
            passphrase_list = json.load(file_handle)
        passphrase = passphrase_list[self._config.challenge_id]
        LOGGER.debug("Passphrase: %s", passphrase)
        return passphrase

    def _get_server_disassembly_filepath(self) -> str:
        with open(self._config.server_disassembly_list) as file_handle:
            server_disassembly_list = json.load(file_handle)
        server_disassembly_filename = server_disassembly_list[self._config.challenge_id]
        server_disassembly_filepath = os.path.join(self._config.server_disassembly_dir, server_disassembly_filename)
        LOGGER.debug("server disassembly filepath: %s", server_disassembly_filepath)
        return server_disassembly_filepath

    def _get_server_application_filename(self) -> str:
        if self._config.vax_os is VaxOs.OPEN_VMS:
            return SERVER_EXE
        elif self._config.vax_os is VaxOs.OPEN_BSD:
            return SERVER
        raise ValueError(f"Unknown VAX OS {self._config.vax_os}")

    def _get_server_disassembly_filename(self) -> str:
        if self._config.vax_os is VaxOs.OPEN_VMS:
            return SERVER_MAR
        elif self._config.vax_os is VaxOs.OPEN_BSD:
            return SERVER_S
        raise ValueError(f"Unknown VAX OS {self._config.vax_os}")
