#!/usr/bin/env python3

import logging
# import signal
import sys

from challenge_status import ChallengeState
from modem import modem_io
from modem.modem import Modem

logging.basicConfig(level=logging.CRITICAL)

# s = signal.signal(signal.SIGINT, signal.SIG_IGN)

# Having the call here is only necessary for debug
ChallengeState.get()

print("Connected to /dev/ttyACM0")
sys.stdout.flush()

try:
    modem = Modem(modem_io.ConsoleIO())
    modem.run()
except KeyboardInterrupt:
    raise
except:
    sys.exit(1)

# signal.signal(signal.SIGINT, s)
