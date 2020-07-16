#!/usr/bin/env python3
import sys

from ntlm_auth.compute_response import ComputeResponse

assert len(sys.argv) == 3, "ms-chap.py usage: challenge_hex password"
# example: ms-chap.py 162d63479f2327ff password

challenge = bytearray.fromhex(sys.argv[1])
password = sys.argv[2]


resp = calc_resp(create_NT_hashed_password_v1(password), challenge)

print(resp.hex())
