import logging
import re
import subprocess
import sys
import time
from enum import IntEnum
from typing import List

from modem import modem
from challenge_status import ChallengeState


class DialupMyServerState(IntEnum):
    USERNAME_PROMPT = 1,
    PASSWORD_PROMPT = 2,
    TERMINAL = 3,
    COMMAND = 4,
    CLOSING = 5,


class DialupMyServer(object):

    def __init__(
            self,
    ):
        self.logger = modem.logger or logging.getLogger(__name__)

        self.state = None
        self.username = ""
        self.password = ""
        self.command = ""
        self.parsed_command = []
        self.command_start = None

    @staticmethod
    def modulation_matches(
            modulation_string: str,
    ):
        # return modulation_string.startswith("V92,1")
        return True

    def tick(
            self,
            input_char: str,
    ):
        next_state = None
        output = ""

        if self.state is None:
            next_state = DialupMyServerState.USERNAME_PROMPT

        if input_char is not None:
            if ord(input_char) in [4]:   # Ctrl-D
                next_state = DialupMyServerState.CLOSING
            else:
                if self.state == DialupMyServerState.USERNAME_PROMPT:
                    if input_char == "\r":
                        next_state = DialupMyServerState.PASSWORD_PROMPT
                    elif ord(input_char) == 127:
                        if len(self.username) > 0:
                            self.username = self.username[:-1]
                            output += ""  # "\b \b"
                    elif re.match(r'[\r -~]+$', input_char):  # Printable ASCII + CR
                        self.username += input_char
                        output += ""  # input_char
                elif self.state == DialupMyServerState.PASSWORD_PROMPT:
                    if input_char == "\r":
                        if self.username == ChallengeState.get().user_server_username \
                                and self.password == ChallengeState.get().user_server_password:
                            next_state = DialupMyServerState.TERMINAL
                        else:
                            output += '                          oooo$$$$$$$$$$$$oooo\n'
                            output += '                      oo$$$$$$$$$$$$$$$$$$$$$$$$o\n'
                            output += '                   oo$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o         o$   $$ o$\n'
                            output += '   o $ oo        o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o       $$ $$ $$o$\n'
                            output += 'oo $ $ "$      o$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$o       $$$o$$o$\n'
                            output += '"$$$$$$o$     o$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$o    $$$$$$$$\n'
                            output += '  $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$\n'
                            output += '  $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  """$$$\n'
                            output += '   "$$$""""$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$\n'
                            output += '    $$$   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$o\n'
                            output += '   o$$"   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$o\n'
                            output += '   $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" "$$$$$$ooooo$$$$o\n'
                            output += '  o$$$oooo$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   o$$$$$$$$$$$$$$$$$\n'
                            output += '  $$$$$$$$"$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$""""""""\n'
                            output += ' """"       $$$$    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$"      o$$$\n'
                            output += '            "$$$o     """$$$$$$$$$$$$$$$$$$"$$"         $$$\n'
                            output += '              $$$o          "$$""$$$$$$""""           o$$$\n'
                            output += '               $$$$o                                o$$$"\n'
                            output += '                "$$$$o      o$$$$$$o"$$$$o        o$$$$\n'
                            output += '                  "$$$$$oo     ""$$$$o$$$$$o   o$$$$""\n'
                            output += '                     ""$$$$$oooo  "$$$o$$$$$$$$$"""\n'
                            output += '                        ""$$$$$$$oo $$$$$$$$$$\n'
                            output += ' > Bad login <                  """"$$$$$$$$$$$\n'
                            output += '                                    $$$$$$$$$$$$\n'
                            output += '                                     $$$$$$$$$$"\n'
                            output += '                                      "$$$""  \n'
                            next_state = DialupMyServerState.CLOSING
                    elif ord(input_char) == 127:
                        if len(self.password) > 0:
                            self.password = self.password[:-1]
                            output += ""  # "\b \b"
                    elif re.match(r'[\r -~]+$', input_char):
                        self.password += input_char
                        output += ""  # "*"
                elif self.state == DialupMyServerState.TERMINAL:
                    if input_char == "\r":
                        next_state, terminal_output = self.start_command()
                        output += terminal_output
                    elif ord(input_char) == 127:
                        if len(self.command) > 0:
                            self.command = self.command[:-1]
                            output += ""  # "\b \b"
                    elif re.match(r'[\r -~]+$', input_char):
                        self.command += input_char
                        output += ""  # input_char

        if next_state is not None:
            self.state = next_state
            if self.state == DialupMyServerState.USERNAME_PROMPT:
                output += " _     _____ _____ _____ _   _ \n"
                output += "| |   |  _  |  __ \_   _| \ | |\n"
                output += "| |   | | | | |  \/ | | |  \| |\n"
                output += "| |   | | | | | __  | | | . ` |\n"
                output += "| |___\ \_/ / |_\ \_| |_| |\  |\n"
                output += "\_____/\___/ \____/\___/\_| \_/\n"
                output += "\nUsername: "
            elif self.state == DialupMyServerState.PASSWORD_PROMPT:
                output += "Password: "
            elif self.state == DialupMyServerState.TERMINAL:
                output += "\nfakesh-4.4$ "

        return output, (self.state == DialupMyServerState.CLOSING)

    def start_command(
            self,
    ):
        # TODO - rework me
        sys.stdout.write("\r")
        sys.stdout.flush()

        self.command_start = time.time()
        self.parsed_command = list(filter(None, self.command.strip().split(" ")))
        if len(self.parsed_command) == 0:
            self.command = ""
            self.parsed_command = []
            return DialupMyServerState.TERMINAL, ""

        executable = self.parsed_command[0]
        arguments = self.parsed_command[1:]

        if executable == "ping":
            # TODO - don't wrap it so much - use the real ping
            show_failure = False

            if len(arguments) not in [1, 3]:
                show_failure = True

            IP_REGEX = r'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
            HEX_REGEX = r'[0-9a-fA-F]{0,32}'
            SAFE_REGEX = r'["\']?[a-zA-Z0-9\-_.]["\']?'

            out_args = []
            while len(arguments):
                arg = arguments.pop(0)
                if arg == '-p':
                    out_args.append(arg)
                    p_arg = arguments.pop(0)
                    m = re.match(HEX_REGEX, p_arg)
                    if m is None:
                        show_failure = True
                        break
                    out_args.append(m.group(0))
                else:
                    m = re.match(IP_REGEX, arg)
                    if m is None:
                        show_failure = True
                        break
                    out_args.append(m.group(0))
                    break
            arguments = out_args
            '''
            for idx, argument in enumerate(arguments):
                if idx == 0 and len(arguments) == 3 and argument == "-p":
                    pass
                elif ((idx == 0 and len(arguments) == 1) or (idx == 2)) and re.match(SAFE_REGEX, argument):
                    # Allow quoted parameters, but ensure the quotes match
                    if argument.count('\'') not in [0, 2] or argument.count('\"') not in [0, 2]:
                        show_failure = True
                        break
                elif idx == 1 and re.match(SAFE_REGEX, argument):
                    # Allow quoted parameters, but ensure the quotes match
                    if argument.count('\'') not in [0, 2] or argument.count('\"') not in [0, 2]:
                        show_failure = True
                        break
                else:
                    show_failure = True
                    break
            '''

            # import ipdb; ipdb.set_trace()
            if not show_failure:
                popen_args = ["ping", "-c1"]
                popen_args.extend(arguments)
                proc = subprocess.Popen(popen_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                stdout, stderr = proc.communicate()
                stdout = stdout.decode("utf-8")
                stderr = stderr.decode("utf-8")
                stdout_lines = stdout.split("\n")
                if len(stderr) > 0:
                    self.command = ""
                    self.parsed_command = []
                    return DialupMyServerState.TERMINAL, stderr.split("\n")[0]
                if proc.returncode != 0 and (" 100% packet loss" not in stdout_lines[-2]):
                    show_failure = True

                if not show_failure:
                    ping_line_offset = 1 if ("PATTERN: " in stdout_lines[0]) else 0
                    ip_address = re.search(
                        r'\([0-9.]+\)',
                        stdout_lines[ping_line_offset]
                    ).group()[1:-1]
                    if ip_address == ChallengeState.get().solution_server_ip:
                        if ChallengeState.get().modem_on_hook:
                            self.command = ""
                            self.parsed_command = []
                            return DialupMyServerState.TERMINAL, self.fake_timeout(stdout_lines)
                        elif "PATTERN: " in stdout_lines[0]:
                            pattern = stdout_lines[0].split(" ")[1][2:]
                            if modem.causes_modem_hangup(pattern):
                                ChallengeState.get().set_modem_on_hook()
                                self.command = ""
                                self.parsed_command = []
                                return DialupMyServerState.TERMINAL, self.fake_timeout(stdout_lines)
                    self.command = ""
                    self.parsed_command = []
                    return DialupMyServerState.TERMINAL, stdout
            self.command = ""
            self.parsed_command = []
            return DialupMyServerState.TERMINAL, "Usage: ping [-p pattern] destination"
        elif executable in ["ls", "help", "dir", "?"]:
            self.command = ""
            self.parsed_command = []
            return DialupMyServerState.TERMINAL, "ls\nping\nexit"
        elif executable in ["exit", "quit", "q"]:
            self.command = ""
            self.parsed_command = []
            return DialupMyServerState.CLOSING, ""
        else:
            self.command = ""
            self.parsed_command = []
            return DialupMyServerState.TERMINAL, f"{executable}: command not found"

    def fake_timeout(
            self,
            ping_stdout_lines: List[str],
    ):
        ping_index = 0
        if ping_stdout_lines[0].startswith("PATTERN: "):
            ping_index = 1

        summary_index = None
        for index, line in enumerate(ping_stdout_lines):
            if line.startswith("--- "):
                summary_index = index
                break

        result = list(ping_stdout_lines[0:1 + ping_index])
        result.extend([
            "",
            ping_stdout_lines[summary_index],
            "1 packets transmitted, 0 received, 100% packet loss, time 0ms",
            ""
        ])

        result_str = "\n".join(result)
        time.sleep(2)     # Simulate timeout
        return result_str
