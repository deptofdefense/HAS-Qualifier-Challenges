#!/usr/bin/env python3

import os
import subprocess
import sys
import tempfile

from challenge_status import ChallengeState


def generate_local_script(challenge: ChallengeState):
    local_script_fh, local_script_path = tempfile.mkstemp()
    os.write(local_script_fh, f'2900\n'.encode("ascii"))
    os.write(local_script_fh, f'$"rocketman\\r"\n'.encode("ascii"))
    os.write(local_script_fh, f'510\n'.encode("ascii"))
    os.write(local_script_fh, f'$"{challenge.solution_server_password}\\r"\n'.encode("ascii"))
    os.write(local_script_fh, f'10000\n'.encode("ascii"))
    os.write(local_script_fh, f'""\n'.encode("ascii"))
    return local_script_path


def generate_remote_script():
    remote_script_fh, remote_script_path = tempfile.mkstemp()
    # TODO - pull strings from elsewhere
    os.write(remote_script_fh, f'1500\n'.encode("ascii"))
    os.write(remote_script_fh, f'$"\\r\\n         SATNET LOGIN\\r\\nUNAUTHORIZED ACCESS PROHIBITED\\r\\n\\r\\nUsername: "\n'.encode("ascii"))
    os.write(remote_script_fh, f'450\n'.encode("ascii"))
    os.write(remote_script_fh, f'$"\\nPassword: "\n'.encode("ascii"))
    os.write(remote_script_fh, f'800\n'.encode("ascii"))
    os.write(remote_script_fh, f'$"\\n\\nsatnet> "\n'.encode("ascii"))
    os.write(remote_script_fh, f'1000\n'.encode("ascii"))
    os.write(remote_script_fh, f'""\n'.encode("ascii"))
    return remote_script_path


if __name__ == "__main__":
    challenge = ChallengeState(persist=False)

    env = os.environ.copy()
    env['SOLUTION_NUMBER'] = challenge.solution_server_number
    env['SOLUTION_NUMBER_AREA_CODE'] = challenge.solution_server_number[0:3]
    env['PPP_CHALLENGE'] = challenge.ppp_challenge
    env['PPP_PASSWORD'] = challenge.ppp_password
    env['USERNAME_SUFFIX'] = challenge.username_suffix
    env['MY_SERVER_NUMBER_DASHED'] = f"{challenge.user_server_number[0:3]}" \
        f"-{challenge.user_server_number[3:6]}" \
        f"-{challenge.user_server_number[6:10]}"

    files = []

    mix_proc = subprocess.Popen(
        ['bash', './modulation/do_mix.sh'],
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    mix_proc_stdout, mix_proc_stderr = mix_proc.communicate()
    if mix_proc.returncode != 0:
        sys.stderr.write("Error executing generator: do_mix\n\n" + mix_proc_stderr.decode("ascii"))
        exit(1)
    files.extend(list(filter(None, mix_proc_stdout.decode("ascii").split('\n'))))

    note_proc = subprocess.Popen(
        ['bash', './modulation/do_note.sh'],
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    note_proc_stdout, note_proc_stderr = note_proc.communicate()
    if note_proc.returncode != 0:
        sys.stderr.write("Error executing generator: do_note\n\n" + note_proc_stderr.decode("ascii"))
        exit(2)
    files.extend(list(filter(None, note_proc_stdout.decode("ascii").split('\n'))))
    # files.append(challenge._debug_path)

    print("\n".join(files))
