import os


def get_flag() -> str:
    return os.getenv("FLAG", "FLAG{Placeholder}")
