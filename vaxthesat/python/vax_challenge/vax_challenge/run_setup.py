import logging
import sys

from vax_challenge.vax_challenge import VaxChallenge
from vax_common.vax_config import get_config


LOGGER = logging.getLogger("vax_challenge.run_setup")
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)


def main():
    vax_challenge = VaxChallenge(get_config())
    vax_challenge.run_setup()


if __name__ == "__main__":
    main()
