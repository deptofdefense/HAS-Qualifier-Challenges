import logging
import sys

from vax_common.vax_config import get_config
from vax_generator.vax_generator import VaxGenerator

logging.basicConfig(stream=sys.stderr, level=logging.INFO)


def main():
    generator = VaxGenerator(get_config())
    generator.run()


if __name__ == "__main__":
    main()
