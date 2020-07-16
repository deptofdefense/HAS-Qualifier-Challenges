import os


def get_random_seed() -> int:
    return int(os.getenv("SEED", "0"))


