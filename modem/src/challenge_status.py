import hashlib
import os
import random


class ChallengeState(object):
    __instance = None

    SEED_MODIFIER = "Dial-up modems are pretty neat"

    def __init__(
            self,
            persist=False,
    ):
        if ChallengeState.__instance is not None:
            raise Exception("Multiple singleton instantiations")
        else:
            # File store
            self._seed = os.environ.get("SEED", "0")
            path_prefix = "/data/" if persist else "/tmp/"  # There is no /data in solution dockers
            self._challenge_state_path = path_prefix + "challenge_state-" + self._seed
            self._debug_path = path_prefix + "challenge_debug-" + self._seed

            # Default values for stateful data
            self.modem_on_hook = False

            # Data derived from _seed
            self._modified_seed = hashlib.sha256((self._seed + ChallengeState.SEED_MODIFIER).encode("ascii")).hexdigest()
            random.seed(self._modified_seed)

            # Data derived from _modified_seed - User server
            self.user_server_number = "{:03d}555{:04d}".format(random.randint(200, 399), random.randint(100, 199))
            self.user_server_username = "hax"
            self.user_server_password = "hunter2"

            # Data derived from _modified_seed - Solution server
            self.solution_server_number = "{:03d}555{:04d}".format(random.randint(400, 499), random.randint(100,199))

            self.solution_server_ip = "93.184.216.34"   # example.com
            self.solution_server_username = "rocketman"
            self.solution_server_password = hashlib.sha256(
                str(random.random()).encode("ascii")
            ).hexdigest()[:24]

            self.flag = os.environ.get("FLAG", "FLAG{Placeholder}")

            # Data derived from _modified_seed - PPP
            self.ppp_challenge = bytearray(random.getrandbits(8) for _ in range(8)).hex()
            self.ppp_password = str(random.randint(0, 9999)).rjust(4, '0')
            self.username_suffix = str(random.randint(0, 9999)).rjust(4, '0')

            # Hax
            self.solution_server_password = self.ppp_password
            self.solution_server_username += self.username_suffix

            # Create / read state and write back
            self._read_file_store()
            self._write_file_store()

            self._log_derived_values()
            ChallengeState.__instance = self

    @staticmethod
    def get():  # type: (...) -> ChallengeState
        if ChallengeState.__instance is None:
            ChallengeState()
        return ChallengeState.__instance

    # Stateful data setters

    def set_modem_on_hook(self):
        self.modem_on_hook = True
        self._write_file_store()

    # Stateful serialization

    def _serialize_state(self):
        return "\n".join([
            "1" if self.modem_on_hook else "0",
        ])

    def _deserialize_state(
            self,
            data,   # type: str
    ):
        data_lines = data.split("\n")
        self.modem_on_hook = True if data_lines[0] == "1" else False

    def _read_file_store(self):
        if not os.path.exists(self._challenge_state_path):
            self._write_file_store()
        with open(self._challenge_state_path, "r") as fh:
            self._deserialize_state(fh.read())

    def _write_file_store(self):
        with open(self._challenge_state_path, "w+") as fh:
            fh.write(self._serialize_state())

    # Debug helpers

    def _log_derived_values(self):
        with open(self._debug_path, "w+") as fh:
            fh.write(
                "flag:                     " + self.flag + "\n"
                "\n"
                "_seed:                    " + self._seed + "\n"
                "_modified_seed:           " + self._modified_seed + "\n"
                "user_server_number:       " + self.user_server_number + "\n"
                "solution_server_number:   " + self.solution_server_number + "\n"
                "solution_server_password: " + self.solution_server_password + "\n"
                "ppp_challenge:            " + self.ppp_challenge + "\n"
                "ppp_password:             " + self.ppp_password + "\n"
                "username_suffix:          " + self.username_suffix + "\n"
                "solution_server_username: " + self.solution_server_username + "\n"
                "\n"
                "NON-RANDOMIZED VALUES\n"
                "user_server_username:     " + self.user_server_username + "\n"
                "user_server_password:     " + self.user_server_password + "\n"
                "solution_server_ip:       " + self.solution_server_ip + "\n"
            )
