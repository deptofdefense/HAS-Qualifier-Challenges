#!/usr/bin/env python3

import binascii
import logging
import re
import sys
import time
from enum import IntEnum
from typing import Optional, Tuple, Dict, Callable

from challenge_status import ChallengeState
from challenge.dialup_my_server import DialupMyServer
from challenge.dialup_solution_server import DialupSolutionServer
from modem import modem_io


logger = logging.getLogger(__name__)


def causes_modem_hangup(pattern: str):
    """Simulate a modem and check the modem state after the input sequence completes"""
    pattern = binascii.unhexlify(pattern * 3).decode("charmap")
    modem = Modem(modem_io.NullIO(pattern))
    modem.state = ModemState.OFF_HOOK_CONNECTED
    modem.run(end_on_empty_input=True)
    return not modem.state.is_off_hook()


class ModemState(IntEnum):
    ON_HOOK_INATTENTIVE = 0,

    ON_HOOK_ATTENTIVE = 1,
    ON_HOOK_COMMAND_RUNNING = 3,
    ON_HOOK_COMMAND_FINISHED = 4,

    OFF_HOOK_ANSWERING = 10,
    OFF_HOOK_DIALING = 11,
    OFF_HOOK_CONNECTING = 12,

    OFF_HOOK_CONNECTED = 13,
    OFF_HOOK_CONNECTED_ESCAPED_ATTENTIVE = 14,
    OFF_HOOK_CONNECTED_ESCAPED_COMMAND_RUNNING = 16,
    OFF_HOOK_CONNECTED_ESCAPED_COMMAND_FINISHED = 17,

    def is_off_hook(self):
        return self.value >= ModemState.OFF_HOOK_ANSWERING.value

    def is_connected(self):
        return self.value >= ModemState.OFF_HOOK_CONNECTED.value


class ModemConfig(object):
    def __init__(self):
        self.command_echo = True
        self.line_end_char = ord("\r")
        self.modulation = "V92,1,300,48000,300,56000"


class Modem(object):
    MODEM_ID = "56000\n"

    ATTENTION_STRING = "AT"
    ESCAPE_STRING = "+++AT"

    ALLOWED_CARRIERS = ["B103", "B212", "V21", "V22", "V22B", "V23C", "V32", "V32B", "V34", "V90",
                        "V92", "ALM1", "ALM2"]
    MS_SHOW_ALLOWABLE = "(B103,B212,V21,V22,V22B,V23C,V32,V32B,V34,V90,V92,ALM1,ALM2),(0,1),(300-" \
                        "33600),(300-48000),(300-56000),(300-56000)"

    def __init__(
            self,
            io: modem_io.BaseIO,
    ):
        self.io = io
        self.logger = logger or logging.getLogger(__name__)

        self.config = ModemConfig()
        self.state = ModemState.ON_HOOK_INATTENTIVE
        self.remote_server = None

        self.remote_rx_buffer = []
        self.at_buffer = ""
        self.escape_buffer = ""

        self.command_input = ""
        self.command_succeeded = True
        self.command_state_change = None

        self.dial_number = ""

    def run(
            self,
            end_on_empty_input: bool = False,
    ):
        state_time_start = time.time()

        while True:
            # We busy loop here while polling for input, so be nice and yield for a bit.
            time.sleep(0.005)

            next_state = None

            # Update local input
            do_echo = self.config.command_echo and self.state in [
                ModemState.ON_HOOK_INATTENTIVE,
                ModemState.ON_HOOK_ATTENTIVE,
                ModemState.OFF_HOOK_CONNECTED_ESCAPED_ATTENTIVE,
            ]
            can_delete = len(self.command_input) > 0 and \
                         self.state == ModemState.ON_HOOK_ATTENTIVE or \
                         self.state == ModemState.OFF_HOOK_CONNECTED_ESCAPED_ATTENTIVE
            input_char, did_delete = self.io.getchar(do_echo, can_delete)

            if end_on_empty_input and input_char is None:
                break

            # For all local processing, treat the input as uppercase
            if input_char is not None and self.state != ModemState.OFF_HOOK_CONNECTED:
                input_char = input_char.upper()

            # 1 - Process local input
            if input_char is not None:
                if self.state == ModemState.ON_HOOK_INATTENTIVE:
                    if self._at_sequence_complete(input_char):
                        self.at_buffer = ""
                        next_state = ModemState.ON_HOOK_ATTENTIVE

                elif self.state == ModemState.ON_HOOK_ATTENTIVE:
                    if ord(input_char) == self.config.line_end_char:
                        self.command_succeeded = True
                        self.command_state_change = None
                        next_state = ModemState.ON_HOOK_COMMAND_RUNNING
                    elif did_delete:
                        self.command_input = self.command_input[:-1]
                    else:
                        self.command_input += input_char

                elif self.state == ModemState.OFF_HOOK_ANSWERING:
                    self.io.puts("NO CARRIER\n")
                    next_state = ModemState.ON_HOOK_INATTENTIVE

                elif self.state == ModemState.OFF_HOOK_DIALING:
                    self.io.puts("NO CARRIER\n")
                    next_state = ModemState.ON_HOOK_INATTENTIVE

                elif self.state == ModemState.OFF_HOOK_CONNECTING:
                    self.io.puts("NO CARRIER\n")
                    next_state = ModemState.ON_HOOK_INATTENTIVE

                elif self.state == ModemState.OFF_HOOK_CONNECTED:
                    if self._escape_sequence_complete(input_char):
                        self.escape_buffer = ""
                        next_state = ModemState.OFF_HOOK_CONNECTED_ESCAPED_ATTENTIVE

                elif self.state == ModemState.OFF_HOOK_CONNECTED_ESCAPED_ATTENTIVE:
                    if ord(input_char) == self.config.line_end_char:
                        self.command_succeeded = True
                        self.command_state_change = None
                        next_state = ModemState.OFF_HOOK_CONNECTED_ESCAPED_COMMAND_RUNNING
                    elif did_delete:
                        self.command_input = self.command_input[:-1]
                    else:
                        self.command_input += input_char

            # 2 - Input-independent checks
            if self.state == ModemState.ON_HOOK_COMMAND_RUNNING:
                if len(self.command_input) == 0:
                    next_state = self._state_after_command()
                else:
                    command_state = self.parse_command()
                    if command_state is not None:
                        self.command_state_change = command_state

            elif self.state == ModemState.OFF_HOOK_CONNECTED_ESCAPED_COMMAND_RUNNING:
                if len(self.command_input) == 0:
                    next_state = self._state_after_command()
                else:
                    command_state = self.parse_command()
                    if command_state is not None:
                        self.command_state_change = command_state

            elif self.state == ModemState.ON_HOOK_COMMAND_FINISHED:
                if self.command_state_change is not None:
                    next_state = self.command_state_change
                else:
                    if self.command_succeeded:
                        self.io.puts("OK\n")
                    next_state = ModemState.ON_HOOK_INATTENTIVE

            elif self.state == ModemState.OFF_HOOK_CONNECTED_ESCAPED_COMMAND_FINISHED:
                if self.command_state_change is not None:
                    next_state = self.command_state_change
                else:
                    if self.command_succeeded:
                        self.io.puts("OK\n")
                    # TODO - what would actually happen here?
                    next_state = ModemState.OFF_HOOK_CONNECTED

            # 3 - Temporal checks
            state_time_delta = time.time() - state_time_start
            if self.state == ModemState.OFF_HOOK_DIALING:
                if state_time_delta > 4:
                    # TODO - double check behavior on bad modulation
                    if self.dial_number == ChallengeState.get().solution_server_number \
                            and DialupSolutionServer.modulation_matches(self.config.modulation):
                        if not ChallengeState.get().modem_on_hook:
                            self.io.puts("BUSY\n")
                            next_state = ModemState.ON_HOOK_INATTENTIVE
                        else:
                            self.remote_server = DialupSolutionServer()
                            next_state = ModemState.OFF_HOOK_CONNECTING
                    elif self.dial_number == ChallengeState.get().user_server_number \
                            and DialupMyServer.modulation_matches(self.config.modulation):
                        self.remote_server = DialupMyServer()
                        next_state = ModemState.OFF_HOOK_CONNECTING
                    else:
                        self.io.puts("NO CARRIER\n")
                        next_state = ModemState.ON_HOOK_INATTENTIVE

            elif self.state == ModemState.OFF_HOOK_CONNECTING:
                if state_time_delta > 0.75:
                    next_state = ModemState.OFF_HOOK_CONNECTED

            elif self.state == ModemState.OFF_HOOK_ANSWERING:
                if state_time_delta > 4:
                    self.io.puts("NO CARRIER\n")
                    next_state = ModemState.ON_HOOK_INATTENTIVE

            # Call `tick` on the remote
            if self.state.is_connected() and self.remote_server is not None:
                remote_input_char = input_char if self.state.value == ModemState.OFF_HOOK_CONNECTED.value else None
                output, disconnected = self.remote_server.tick(remote_input_char)
                self.remote_rx_buffer.extend(list(output))
                if disconnected:
                    if self.remote_rx_buffer:
                        self.io.puts(''.join(self.remote_rx_buffer), prefix=False)
                        self.remote_rx_buffer = []
                    time.sleep(0.5)
                    # TODO - double-check behavior here
                    self.io.puts("NO CARRIER\n")
                    next_state = ModemState.ON_HOOK_INATTENTIVE

            # 4 - Check for remote input
            if len(self.remote_rx_buffer) > 0 and self.state == ModemState.OFF_HOOK_CONNECTED:
                remote_char = self.remote_rx_buffer.pop(0)
                self.io.putchar(remote_char)

            # Call `tick` on the IO
            self.io.tick()

            # 5 - Update state
            if next_state is not None:
                logger.debug(f"Changing state from {self.state.name} to {next_state.name}")
                state_time_start = time.time()
                self.state = next_state

                # Events that occur on state change (regardless of previous state)
                if self.state == ModemState.OFF_HOOK_CONNECTED:
                    self.io.puts("CONNECT\n")
                elif not self.state.is_off_hook():
                    if self.remote_rx_buffer:
                        self.io.puts(''.join(self.remote_rx_buffer), prefix=False)
                        self.remote_rx_buffer = []
                    self.remote_server = None

    ################################################################################################
    # Utility functions
    ################################################################################################

    def _at_sequence_complete(
            self,
            input_char,
    ):
        if input_char == Modem.ATTENTION_STRING[len(self.at_buffer)]:
            self.at_buffer += input_char
            return self.at_buffer == Modem.ATTENTION_STRING
        elif input_char == "A":
            self.at_buffer = "A"
            return False
        else:
            self.at_buffer = ""
            return False

    def _escape_sequence_complete(
            self,
            input_char: str,
    ):
        normalized_input_char = input_char.upper()
        if normalized_input_char == Modem.ESCAPE_STRING[len(self.escape_buffer)]:
            self.escape_buffer += normalized_input_char
            return self.escape_buffer == Modem.ESCAPE_STRING
        elif normalized_input_char == "+" and Modem.ESCAPE_STRING[len(self.escape_buffer)] == "A":
            # No-op, since we have a string of three + at the beginning and we got an extra one
            return False
        elif normalized_input_char == "+":
            self.escape_buffer = normalized_input_char
            return False
        else:
            self.escape_buffer = ""
            return False

    def _state_after_command(
            self,
    ):
        if self.state == ModemState.ON_HOOK_COMMAND_RUNNING:
            return ModemState.ON_HOOK_COMMAND_FINISHED
        elif self.state == ModemState.OFF_HOOK_CONNECTED_ESCAPED_COMMAND_RUNNING:
            return ModemState.OFF_HOOK_CONNECTED_ESCAPED_COMMAND_FINISHED
        else:
            raise RuntimeError("Unknown state after command")

    ################################################################################################
    # Command functions
    ################################################################################################

    def do_answer(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        self.command_input = ""
        return ModemState.OFF_HOOK_ANSWERING

    def do_dial(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        parts = user_input.split(";", 1)
        dial_part = parts[0]
        other_part = ""  # parts[1] if (len(parts) > 1) else ""

        # TODO double-check handling of TP,!W@
        # Only the dialing characters
        dial_part = re.sub(r'[^0-9A-D*#]', '', dial_part)

        self.dial_number = dial_part
        self.command_input = other_part
        return ModemState.OFF_HOOK_DIALING

    def do_command_echo(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[01]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        if value == "0":
            self.config.command_echo = False
        elif value == "1":
            self.config.command_echo = True

        self.command_input = other_part
        return None

    def do_hook(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[01]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        self.command_input = other_part
        if not (value == "1" and self.state.is_off_hook()):
            self.io.puts("OK\n")
            return ModemState.ON_HOOK_INATTENTIVE
        return None

    def do_identification(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        self.io.puts(Modem.MODEM_ID)
        self.command_input = user_input
        return None

    def do_speaker_vol(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-3]", user_input)
        if parameter:
            value = self.do_speaker_vol(parameter.group())
            other_part = user_input[parameter.end():]

        # No speaker, just pass
        self.command_input = other_part
        return None

    def do_speaker_onoff(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-2]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        # No speaker, just pass
        self.command_input = other_part
        return None

    def do_online(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        if self.state.is_off_hook():
            self.command_input = other_part
            return ModemState.OFF_HOOK_CONNECTED
        else:
            self.io.puts("ERROR\n")
            self.command_input = ""
            self.command_succeeded = False
            return None

    def do_pulse_dial(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        # We simulate that we only support dtmf dial
        self.command_input = user_input
        return None

    def do_result_code_display(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-1]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        # TODO - implement me

        self.command_input = other_part
        return None

    def do_register(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        parameter = re.match(r"[0-9]+", user_input)
        if parameter:
            register_num = parameter.group()
            next_index = parameter.end()
        else:
            register_num = "0"
            next_index = 0

        user_input = user_input[next_index:]
        equals = re.match(r"=", user_input)
        set_value = None
        if equals:
            user_input = user_input[equals.end():]
            # TODO - may not always be numeric...
            equals_parameter = re.match(r"[0-9]+", user_input)
            if equals_parameter:
                set_value = equals_parameter.group()
                user_input = user_input[equals_parameter.end():]

        query = re.match(r"\?", user_input)
        show_value = False
        if query:
            show_value = True
            user_input = user_input[query.end():]

        # TODO - implement me

        self.command_input = user_input
        return None

    def do_tone_dial(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        # We simulate that we only support dtmf dial
        self.command_input = user_input
        return None

    def do_result_code_format(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-1]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        # TODO - implement me

        self.command_input = other_part
        return None

    def do_call_progress(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-4]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        # TODO - implement me

        self.command_input = other_part
        return None

    def do_reset_config(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        self.config = ModemConfig()
        self.command_input = user_input
        return None

    def do_mode_select(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        # TODO - handle setting partial values
        # TODO - handle automode
        equals = re.match(r"=", user_input)
        set_value = None
        if equals:
            user_input = user_input[equals.end():]
            equals_parameter = re.match(r"[A-Z0-9]+,[0-1],[0-9]+,[0-9]+,[0-9]+,[0-9]+", user_input)
            if equals_parameter:
                set_value = equals_parameter.group()
                user_input = user_input[equals_parameter.end():]

        query = re.match(r"\?", user_input)
        show_value = False
        if query:
            show_value = True
            user_input = user_input[query.end():]

        if equals:
            if set_value is None and not show_value:
                self.io.puts("ERROR\n")
                self.command_input = ""
                self.command_succeeded = False
                return None

            if set_value:
                carrier, automode, min_rate, max_rate, min_rx_rate, max_rx_rate = tuple(
                    set_value.split(",")
                )
                automode = int(automode)
                min_rate = int(min_rate)
                max_rate = int(max_rate)
                min_rx_rate = int(min_rx_rate)
                max_rx_rate = int(max_rx_rate)

                if carrier not in Modem.ALLOWED_CARRIERS or \
                        automode not in [0, 1] or \
                        not (300 <= min_rate <= 33600) or \
                        not (300 <= max_rate <= 48000) or \
                        not (300 <= min_rx_rate <= 56000) or \
                        not (300 <= max_rx_rate <= 56000):
                    self.io.puts("ERROR\n")
                    self.command_input = ""
                    self.command_succeeded = False
                    return None

                self.config.modulation = set_value

        if show_value:
            if equals and not set_value:
                self.io.puts(f"+MS: {Modem.MS_SHOW_ALLOWABLE}\n")
            else:
                self.io.puts(f"+MS: {self.config.modulation}\n")

        # TODO - how to handle data after this?
        self.command_input = ""
        return None

    def do_circuit_109(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-1]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        # TODO - implement me

        self.command_input = other_part
        return None

    def do_circuit_108(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        value = "0"
        other_part = user_input

        parameter = re.match(r"[0-2]", user_input)
        if parameter:
            value = parameter.group()
            other_part = user_input[parameter.end():]

        # TODO - implement me

        self.command_input = other_part
        return None

    def do_debug_exit(
            self,
            user_input: str,
    ) -> None:
        print("\n!!! DEBUG EXIT - REMOVE ME !!!")
        sys.exit(1)

    ################################################################################################
    # Input parsing functions
    ################################################################################################

    @staticmethod
    def _consume_command_chars(
            cmd_format,
            input_string
    ) -> Tuple[str, str]:
        match_end = re.match(cmd_format, input_string).end()
        return input_string[:match_end], input_string[match_end:]

    def parse_command(
            self,
    ) -> Optional[ModemState]:
        command_char = self.command_input[0]
        remaining_chars = self.command_input[1:]

        if command_char in Modem._COMMAND_DICT:
            return Modem._COMMAND_DICT[command_char](self, remaining_chars)
        else:
            self.io.puts("ERROR\n")
            self.command_input = ""
            self.command_succeeded = False
            return None

    def parse_plus(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        for subcommand in Modem._PLUS_COMMAND_DICT:
            if user_input.startswith(subcommand):
                remaining_chars = user_input[len(subcommand):]
                return Modem._PLUS_COMMAND_DICT[subcommand](self, remaining_chars)
        self.io.puts("ERROR\n")
        self.command_input = ""
        self.command_succeeded = False
        return None

    def parse_ampersand(
            self,
            user_input: str,
    ) -> Optional[ModemState]:
        for subcommand in Modem._AMPERSAND_COMMAND_DICT:
            if user_input.startswith(subcommand):
                remaining_chars = user_input[len(subcommand):]
                return Modem._AMPERSAND_COMMAND_DICT[subcommand](self, remaining_chars)
        self.io.puts("ERROR\n")
        self.command_input = ""
        self.command_succeeded = False
        return None

    _COMMAND_DICT: Dict[str, Callable[[str], Optional[ModemState]]] = {
        "A": do_answer,
        "D": do_dial,
        # "E": do_command_echo,
        "H": do_hook,
        "I": do_identification,
        # "L": do_speaker_vol,
        # "M": do_speaker_onoff,
        "O": do_online,
        "P": do_pulse_dial,
        # "Q": do_result_code_display,
        # "S": do_register,
        "T": do_tone_dial,
        # "V": do_result_code_format,
        # "X": do_call_progress,
        "Z": do_reset_config,

        "+": parse_plus,
        "&": parse_ampersand,

        # "!": do_debug_exit,
    }

    _PLUS_COMMAND_DICT: Dict[str, Callable[[str], Optional[ModemState]]] = {
        # "MS": do_mode_select,
    }

    _AMPERSAND_COMMAND_DICT: Dict[str, Callable[[str], Optional[ModemState]]] = {
        # "C": do_circuit_109,
        # "D": do_circuit_108,
        "F": do_reset_config,
    }
