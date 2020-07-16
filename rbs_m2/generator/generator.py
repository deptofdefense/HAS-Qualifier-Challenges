import argparse

from signal_generator import generate_signals_for_seed

ARGS = [
    {
        'args': ('--groundstation-file',),
        'kwargs': {
            'type': str,
            'help': "Local path to file of groundstation locations",
            'required': True
        }
    },
    {
        'args': ('--tle-file',),
        'kwargs': {
            'type': str,
            'help': "Local path to TLE file of satellite orbit parameters (e.g. http://celestrak.com/NORAD/elements/noaa.txt)",
            'required': True
        }
    },
    {
        'args': ('--seed',),
        'kwargs': {
            'type': int,
            'help': "Participant's unique seed for this challenge",
            'required': True
        }
    }
]


def main(args):
    generate_signals_for_seed(
        args.seed >> 2,
        args.tle_file,
        args.groundstation_file
    )


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="~~~ Hacksat medium 2 (Generator) ~~~")
    for arg in ARGS:
        parser.add_argument(*arg['args'], **arg['kwargs'])
    args = parser.parse_args()
    main(args)
