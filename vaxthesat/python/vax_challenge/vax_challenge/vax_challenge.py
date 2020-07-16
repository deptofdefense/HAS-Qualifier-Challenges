import json
import logging
import os
import pty
import shutil

from vax_common.constant import OUTPUT_DIRECTORY
from vax_common.vax_base import VaxBase

LOGGER = logging.getLogger(__name__)
CHALLENGE_DIRECTORY = os.path.join(OUTPUT_DIRECTORY, "challenge_files")
CLIENT_SCRIPT = "/run_client.sh"
PASSPHRASE_FILENAME = "passphrase.txt"
FLAG_FILENAME = "flag.txt"


class VaxChallenge(VaxBase):

    def run_setup(self):
        self._create_challenge_directory()
        self._write_passphrase_file()
        self._write_flag_file()
        self._copy_server_application()
        self._copy_server_disassembly_file()

    def _create_challenge_directory(self):
        """
        Create the challenge directory, clearing it of existing contents.
        """
        if os.path.exists(CHALLENGE_DIRECTORY):
            shutil.rmtree(CHALLENGE_DIRECTORY)
        os.makedirs(CHALLENGE_DIRECTORY)

    def _write_passphrase_file(self):
        passphrase = self._get_passphrase()
        passphrase_filepath = os.path.join(CHALLENGE_DIRECTORY, PASSPHRASE_FILENAME)
        self._write_file(passphrase, passphrase_filepath)

    def _write_flag_file(self):
        flag_filepath = os.path.join(CHALLENGE_DIRECTORY, FLAG_FILENAME)
        self._write_file(self._config.flag, flag_filepath)

    def _write_file(self, file_contents: str, filepath: str) -> None:
        with open(filepath, "w") as file_handle:
            file_handle.write(file_contents)
        LOGGER.debug("Wrote %s", filepath)

    def _copy_server_application(self):
        """
        Copy the server.exe file to the challenge directory.
        """
        with open(self._config.server_application_list) as file_handle:
            server_application_list = json.load(file_handle)
        server_application_filename = server_application_list[self._config.challenge_id]
        source_server_application_filepath = os.path.join(
            self._config.server_application_dir,
            server_application_filename
        )
        destination_server_application_filepath = os.path.join(
            CHALLENGE_DIRECTORY,
            self._get_server_application_filename()
        )
        shutil.copy(source_server_application_filepath, destination_server_application_filepath)
        LOGGER.debug(
            "%s copied to %s",
            source_server_application_filepath,
            destination_server_application_filepath
        )
    def run(self):
        server_mar_filepath= self._output_server_disassembly_file()
        print(server_mar_filepath)

    def _copy_server_disassembly_file(self) -> str:
        """
        Get the disassembly file based on the random seed and copy it to the output directory.
        """
        source_server_disassembly_file = self._get_server_disassembly_filepath()
        destination_server_disassembly_filepath = os.path.join(
            CHALLENGE_DIRECTORY,
            self._get_server_disassembly_filename()
        )
        shutil.copy(source_server_disassembly_file, destination_server_disassembly_filepath)
        LOGGER.debug(
            "%s copied to %s",
            source_server_disassembly_file,
            destination_server_disassembly_filepath
        )

    @staticmethod
    def run_client():
        pty.spawn(CLIENT_SCRIPT)
