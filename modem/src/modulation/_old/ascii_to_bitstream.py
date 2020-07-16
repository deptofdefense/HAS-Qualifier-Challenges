#!/usr/bin/env python3

import sys

delay_value_list = sys.argv[1:]
char_delay = 10
delay_value_pairs = zip(delay_value_list[0::2], delay_value_list[1::2])

output = []

for pair in delay_value_pairs:
    delay, value = pair
    output.extend([1] * int(delay))
    for char in value:
        output.append(0)
        output.extend([int(x) for x in list(bin(ord(char))[2:].rjust(8, '0'))[::-1]])
        output.extend([1] * char_delay)

for bit in output:
    sys.stdout.write(chr(bit))
sys.stdout.flush()
