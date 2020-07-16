import json
import logging
import os
from typing import Optional

from pwnlib.tubes.remote import remote

from vax_common.challenge import get_challenge_id
from vax_common.vax_base import VaxBase
from vax_common.vax_config import VaxOs
from vax_solver.vax_solver_config import VaxSolverConfig

LOGGER = logging.getLogger(__name__)


class VaxSolver(VaxBase):

    def __init__(
            self,
            vax_config: VaxSolverConfig
                 ):
        super(VaxSolver, self).__init__(vax_config)
        self._endline = self._get_endline_format()
        self._host = os.getenv("HOST", "localhost")
        self._port = os.getenv("PORT", 8888)
        self._client = remote(self._host, self._port)

        ticket = os.getenv("TICKET", "")
        if len(ticket):
            self._client.recv(128)
            self._client.send( (ticket + "\n").encode('utf-8'))

        self._client.newline = b"\r\n"
        self._reposition_satellite_command = None  # type: Optional[bytes]

    def _get_endline_format(self):
        if self._config.vax_os is VaxOs.OPEN_VMS:
            return b"\r\n"
        elif self._config.vax_os is VaxOs.OPEN_BSD:
            return b"\n"
        else:
            raise ValueError(f"Unknown VAX OS: {self._config.vax_os}")

    def _get_reposition_satellite_command(self) -> bytes:
        with open(self._config.reposition_satellite_command_list) as file_handle:
            reposition_satellite_command_list = json.load(file_handle)
        reposition_satellite_command = reposition_satellite_command_list[self._config.challenge_id]
        LOGGER.info("Last command: %s", reposition_satellite_command)
        return reposition_satellite_command.encode() + self._endline

    def run(self):
        try:
            self._wait_for_os_to_boot()
            self._log_in()
            self._determine_which_challenge_version_is_running()
            self._configure_decnet()
            self._launch_client()
            self._enable_electrical_power_subsystem_config_mode()
            self._power_attitude_determination_and_control_subsystem()
            self._enable_attitude_determination_and_control_subsystem_config_mode()
            self._send_reposition_satellite_command()
            self._print_flag()
            self._close_client()
        except (Exception, KeyboardInterrupt):
            self._force_shutdown_openvms()
            raise

    def _wait_for_os_to_boot(self):
        step_name = "Wait for OS to boot"
        self._log_start(step_name)
        if self._config.vax_os is VaxOs.OPEN_VMS:
            self._wait_for_openvms_to_boot()
        elif self._config.vax_os is VaxOs.OPEN_BSD:
            self._wait_for_openbsd_to_boot()
        else:
            raise ValueError(f"Unknown VAX OS: {self._config.vax_os}")
        self._log_finish(step_name)

    def _wait_for_openvms_to_boot(self):
        self._client.recvuntil(b"Circuit QNA-0")

    def _wait_for_openbsd_to_boot(self):
        self._client.recvuntil(b"OpenBSD/vax (vaxthesat_server.home.com) (console)")

    def _log_in(self):
        if self._config.vax_os is VaxOs.OPEN_BSD:
            return self._log_in_open_bsd()
        elif self._config.vax_os is VaxOs.OPEN_VMS:
            return self._log_in_open_vms()
        raise ValueError(f"Unknown VAX OS: {self._config.vax_os}")

    def _log_in_open_vms(self):
        step_name = "Log in OpenVMS"
        self._log_start(step_name)
        self._client.send(b"\r\n")
        self._client.sendafter(b"Username: ", b"system\r\n")
        self._client.sendafter(b"Password: ", b"vaxthesat\r\n")
        self._log_finish(step_name)

    def _log_in_open_bsd(self):
        step_name = "Log in OpenBSD"
        self._log_start(step_name)
        self._client.sendafter(b"login: ", b"root\r\n")
        self._client.sendafter(b"Password:", b"vaxthesat!\r\n")
        self._log_finish(step_name)

    def _determine_which_challenge_version_is_running(self):
        if self._config.vax_os is VaxOs.OPEN_BSD:
            return self._deterimine_which_challenge_version_is_running_open_bsd()
        elif self._config.vax_os is VaxOs.OPEN_VMS:
            raise NotImplementedError
        raise ValueError(f"Unknown VAX OS: {self._config.vax_os}")

    def _deterimine_which_challenge_version_is_running_open_bsd(self):
        step_name = "Determine server version running"
        self._log_start(step_name)
        self._client.sendafter(b"# ", b"md5 /root/client/server" + self._endline)
        _ = self._client.recvuntil(b"MD5 (/root/client/server) = ")
        received = self._client.recvuntil(b"# ")
        md5 = received.rstrip(b"\r\n# ").decode()
        LOGGER.info("MD5 of /root/client/server is %s", md5)
        with open(self._config.server_application_md5_list, "r") as file_handle:
            server_application_md5_list = json.load(file_handle)
        md5_found = False
        for challenge_id, md5_from_list in enumerate(server_application_md5_list):
            if md5_from_list == md5:
                md5_found = True
                self._config = VaxSolverConfig(
                    challenge_id,
                    self._config.flag,
                    self._config.vax_os,
                    self._config.reposition_satellite_command_list,
                    self._config.passphrase_list,
                    self._config.server_disassembly_list,
                    self._config.server_application_list,
                    self._config.server_disassembly_dir,
                    self._config.server_application_dir,
                    self._config.server_application_md5_list
                )
                self._reposition_satellite_command = self._get_reposition_satellite_command()
                break
        if md5_found is False:
            raise ValueError("MD5 {} unknown".format(md5))
        self._log_finish(step_name)

    def _configure_decnet(self):
        # DECnet configuration is only needed for OPEN_VMS
        if self._config.vax_os is VaxOs.OPEN_BSD:
            return
        step_name = "Configure decnet"
        self._log_start(step_name)
        self._client.sendafter(b"$ ", b"run sys$system:ncp\r\n")
        self._client.sendafter(b"NCP>", b"define node 2.20 name CHAL1\r\n")
        self._client.sendafter(b"NCP>", b"set known nodes all\r\n")
        self._client.sendafter(b"NCP>", b"EXIT\r\n")
        self._log_finish(step_name)

    def _launch_client(self):
        step_name = "Launch client"
        self._log_start(step_name)
        if self._config.vax_os is VaxOs.OPEN_VMS:
            self._launch_client_open_vms()
        elif self._config.vax_os is VaxOs.OPEN_BSD:
            self._launch_client_open_bsd()
        else:
            raise ValueError(f"Unknown VAX OS: {self._config.vax_os}")
        self._log_finish(step_name)

    def _launch_client_open_vms(self):
        self._client.sendafter(b"$ ", b"client\r\n")

    def _launch_client_open_bsd(self):
        self._client.send(b"client 10.0.0.20\n")

    def _enable_electrical_power_subsystem_config_mode(self):
        step_name = "Enable Electrical Power Subsystem config mode"
        self._log_start(step_name)
        # received = self._client.recvuntil(b"COMMAND $")
        # LOGGER.info(received.decode())
        # self._client.send(b"EPS STATE CONFIG\n")
        self._client.sendafter(b"COMMAND $", b"EPS STATE CONFIG" + self._endline)
        self._log_finish(step_name)

    def _power_attitude_determination_and_control_subsystem(self):
        step_name = "Enable power to Attitude Determination and Control Substation"
        self._log_start(step_name)
        # received = self._client.recvuntil(b"COMMAND $")
        # LOGGER.info(received.decode())
        # self._client.send(b"EPS CFG ADCS ON\n")
        self._client.sendafter(b"COMMAND $", b"EPS CFG ADCS ON" + self._endline)
        self._log_finish(step_name)

    def _enable_attitude_determination_and_control_subsystem_config_mode(self):
        step_name = "Enable Attitude Determination and Control Substation config mode"
        self._log_start(step_name)
        # received = self._client.recvuntil(b"COMMAND $")
        # LOGGER.info(received.decode())
        # self._client.send(b"ADCS STATE CONFIG\n")
        self._client.sendafter(b"COMMAND $", b"ADCS STATE CONFIG" + self._endline)
        self._log_finish(step_name)

    def _send_reposition_satellite_command(self):
        step_name = "Send reposition satellite command"
        self._log_start(step_name)
        self._client.sendafter(b"COMMAND $", self._reposition_satellite_command)
        self._log_finish(step_name)

    def _print_flag(self):
        received = self._client.recvuntil([b"# ERROR:", b"FLAG="])
        error_message = self._client.recvuntil(b"##############################################################################")
        full_received = received.decode() + error_message.decode()
        LOGGER.info("Reposition satellite command result:\n%s", full_received)
        if b"FLAG=" not in received:
            raise RuntimeError(
                f"Did not detect the flag in the response to the reposition satellite command:\n"
                f"{full_received}"
            )

    def _close_client(self):
        self._client.sendthen(b"$ ", b"exit\r\n")

    def _force_shutdown_openvms(self):
        self._client.send(b"\x05\r\n")

    def _log_start(self, step_name: str):
        LOGGER.info("%s step: STARTING", step_name)

    def _log_finish(self, step_name: str):
        LOGGER.info("%s step: FINISHED", step_name)

