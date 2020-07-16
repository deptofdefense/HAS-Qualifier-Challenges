import random

from vax_common.random_seed import get_random_seed

NUMBER_OF_CHALLENGE_VARIANTS = 100


def get_challenge_id() -> int:
    """
    Get the challenge ID, a number from 1 to NUMBER_OF_CHALLNEGE_VARIANTS.
    """
    random_seed = get_random_seed()
    random.seed(random_seed)
    variant_number = random.randint(0, NUMBER_OF_CHALLENGE_VARIANTS - 1)
    return variant_number
