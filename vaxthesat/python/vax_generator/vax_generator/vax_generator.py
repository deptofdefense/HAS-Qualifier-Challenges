import logging
import os
import shutil

from vax_common.constant import OUTPUT_DIRECTORY
from vax_common.vax_base import VaxBase

LOGGER = logging.getLogger(__name__)


class VaxGenerator(VaxBase):

    def run(self):
        server_disassembly_filepath= self._output_server_disassembly_file()
        print(server_disassembly_filepath)

    def _output_server_disassembly_file(self) -> str:
        """
        Get the disassembly file based on the random seed and copy it to the output directory.
        """
        source_server_disassembly_file = self._get_server_disassembly_filepath()
        destination_server_disassembly_filepath = os.path.join(
            OUTPUT_DIRECTORY,
            self._get_server_disassembly_filename()
        )
        shutil.copy(source_server_disassembly_file, destination_server_disassembly_filepath)
        LOGGER.debug(
            "%s copied to %s",
            source_server_disassembly_file,
            destination_server_disassembly_filepath
        )
        return destination_server_disassembly_filepath
