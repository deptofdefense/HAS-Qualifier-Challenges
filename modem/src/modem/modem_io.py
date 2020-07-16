"""
File for emulating slower I/O via a serial connection
"""

import abc
import re
import select
import sys


class BaseIO(abc.ABC):
    def __init__(self):
        pass

    @abc.abstractmethod
    def getchar(
            self,
            echo,
            can_delete=False,
    ):
        pass

    @abc.abstractmethod
    def puts(
            self,
            string: str,
            prefix: bool = True,
    ):
        pass

    @abc.abstractmethod
    def putchar(
            self,
            char: str,
    ):
        pass

    @abc.abstractmethod
    def tick(
            self,
    ):
        pass


class ConsoleIO(BaseIO):
    # Instead of sending one character at a time, we send 3... better for network
    PRINT_DELAY = 3

    def __init__(
            self,
    ):
        super().__init__()
        self.print_delay = ConsoleIO.PRINT_DELAY
        self.print_queue = []
        self.input_buffer = []

    def getchar(
            self,
            echo,
            can_delete=False,
    ):
        echo = False    # Hack
        did_delete = False
        input_char = None

        try:
            if select.select([sys.stdin], [], [], 0) == ([sys.stdin], [], []):
                # print(f"Reading input chars...")
                input_chars = list(sys.stdin.readline())
                self.input_buffer.extend(input_chars)
                # print(f"Got {len(input_chars)} characters of input")
        except KeyboardInterrupt:
            pass
        if len(self.input_buffer) > 0:
            input_char = self.input_buffer.pop(0)
        if input_char == "\n":
            input_char = "\r"

        if echo:
            if ord(input_char) == 127:
                if can_delete:    # TODO - why is this needed? It's delete...
                    self.putchar("\b \b")
                    did_delete = True
                else:
                    return None, did_delete
            elif re.match(r'[\r -~]+$', input_char):  # Printable ASCII + CR
                self.putchar(input_char)
        return input_char, did_delete

    def puts(
            self,
            string: str,
            prefix: bool = True,
    ):
        prefix = False  # Hack
        if prefix:
            self.putchar("\n")
        for char in string:
            self.putchar(char)

    def putchar(
            self,
            char: str,
    ):
        self.print_queue.append(char)

    def tick(
            self,
    ):
        self.print_delay -= 1
        if not self.print_delay:
            self.print_delay = ConsoleIO.PRINT_DELAY
            for _ in range(0, ConsoleIO.PRINT_DELAY):
                if self.print_queue:
                    char = self.print_queue.pop(0)
                    sys.stdout.write(char)
            sys.stdout.flush()


class NullIO(BaseIO):
    def __init__(
            self,
            input_string: str,
    ):
        super().__init__()
        self.input_string = input_string
        self.input_index = 0

    def getchar(
            self,
            echo,
            can_delete=False,
    ):
        did_delete = False

        if self.input_index >= len(self.input_string):
            return None, did_delete

        input_char = self.input_string[self.input_index]
        self.input_index += 1

        if echo:
            if ord(input_char) == 127:
                if can_delete:    # TODO - why is this needed? It's delete...
                    self.putchar("\b \b")
                    did_delete = True
                else:
                    return None, did_delete
            elif input_char != "\n":
                self.putchar(input_char)
            else:
                self.putchar("\r")
        return input_char, did_delete

    def puts(
            self,
            string: str,
            prefix: bool = True,
    ):
        pass

    def putchar(
            self,
            char: str,
    ):
        pass

    def tick(
            self,
    ):
        pass
