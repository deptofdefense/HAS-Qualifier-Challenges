import re
import time
from enum import IntEnum

from challenge_status import ChallengeState


class DialupSolutionServerState(IntEnum):
    USERNAME_PROMPT = 1,
    PASSWORD_PROMPT = 2,
    TERMINAL = 3,
    CLOSING = 5,


class DialupSolutionServer(object):
    LOADING_TIME = 16

    MODULATIONS = [
        "B103,0,300,300,300,300",
        "B103,1,300,300,300,300",
    ]

    def __init__(
            self,
    ):
        self.state = None
        self.username = ""
        self.password = ""
        self.command = ""
        self.parsed_command = []
        self.command_start = None
        self.printed_login = False
        self.delay_start = None

    @staticmethod
    def modulation_matches(
            modulation_string: str,
    ):
        # return modulation_string in DialupSolutionServer.MODULATIONS
        return True

    def tick(
            self,
            input_char: str,
    ):
        next_state = None
        output = ""

        if self.state is None:
            output += "*   *   . *  *    * .   *   * . *   *  .  \n"
            output += "    .  *   *   .    * .    . *      .  *  \n"
            output += " *   +------------------------------+     \n"
            output += "   . |            SATNET            |   * \n"
            output += "     +------------------------------+ .   \n"
            output += "  .  |    UNAUTHORIZED ACCESS IS    |     \n"
            output += "     |     STRICTLY PROHIBITED      |     \n"
            output += ".    +------------------------------+   . \n"
            output += "         .             .                  \n"
            output += "                                  .       \n"
            output += "                                          \n"
            output += "Setting up - this will take a while..."
            next_state = DialupSolutionServerState.USERNAME_PROMPT

        # Discourage brute-forcing here. It's a valid method (if they don't want to brute-force the
        # hash for whatever reason), but isn't guaranteed, will take a while, and should be
        # unattractive
        if not self.printed_login and self.delay_start \
                and time.time() - self.delay_start >= DialupSolutionServer.LOADING_TIME:
            output += "\n\n"
            output += "LOGIN\n"
            output += "Username: "
            self.delay_start = None
            self.printed_login = True

        if self.printed_login and input_char is not None:
            if ord(input_char) in [4]:   # Ctrl-D
                next_state = DialupSolutionServerState.CLOSING
            else:
                if self.state == DialupSolutionServerState.USERNAME_PROMPT:
                    if input_char == "\r":
                        next_state = DialupSolutionServerState.PASSWORD_PROMPT
                    elif ord(input_char) == 127:
                        if len(self.username) > 0:
                            self.username = self.username[:-1]
                            output += ""  # "\b \b"
                    elif re.match(r'[\r -~]+$', input_char):  # Printable ASCII + CR
                        self.username += input_char
                        output += ""  # input_char
                elif self.state == DialupSolutionServerState.PASSWORD_PROMPT:
                    if input_char == "\r":
                        time.sleep(2)
                        if self.username == ChallengeState.get().solution_server_username \
                                and self.password == ChallengeState.get().solution_server_password:
                            next_state = DialupSolutionServerState.TERMINAL
                        else:
                            output += "\nAUTHORIZATION FAILURE\n"
                            next_state = DialupSolutionServerState.CLOSING
                    elif ord(input_char) == 127:
                        if len(self.password) > 0:
                            self.password = self.password[:-1]
                            output += ""  # "\b \b"
                    elif re.match(r'[\r -~]+$', input_char):
                        self.password += input_char
                        output += ""  # "*"
                elif self.state == DialupSolutionServerState.TERMINAL:
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
            if self.state == DialupSolutionServerState.USERNAME_PROMPT:
                self.delay_start = time.time()
            if self.state == DialupSolutionServerState.PASSWORD_PROMPT:
                time.sleep(1.5)
                output += "Password: "
            elif self.state == DialupSolutionServerState.TERMINAL:
                output += "\nsatnet> "

        return output, (self.state == DialupSolutionServerState.CLOSING)

    def start_command(
            self,
    ):
        self.command_start = time.time()
        self.parsed_command = list(filter(None, self.command.strip().split(" ")))
        if len(self.parsed_command) == 0:
            self.command = ""
            self.parsed_command = []
            return DialupSolutionServerState.TERMINAL, ""

        executable = self.parsed_command[0]
        arguments = self.parsed_command[1:]

        if executable == "flag":
            self.command = ""
            self.parsed_command = []
            return DialupSolutionServerState.TERMINAL, f"{ChallengeState.get().flag}"
        elif executable in ["ls", "help", "dir", "?"]:
            self.command = ""
            self.parsed_command = []
            return DialupSolutionServerState.TERMINAL, "ls\nflag\nexit"
        elif executable in ["exit", "quit", "q"]:
            self.command = ""
            self.parsed_command = []
            return DialupSolutionServerState.CLOSING, ""
        else:
            self.command = ""
            self.parsed_command = []
            return DialupSolutionServerState.TERMINAL, f"{executable}: command not found"

