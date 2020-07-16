import logging
import sys

from vax_solver.vax_solver import VaxSolver
from vax_solver.vax_solver_config import get_vax_solver_config

logging.basicConfig(stream=sys.stderr, level=logging.INFO)


def main():
    solver = VaxSolver(get_vax_solver_config())
    solver.run()


if __name__ == "__main__":
    main()
