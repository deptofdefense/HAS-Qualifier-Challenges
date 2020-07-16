# Hack-a-Sat 2020 Qualifier #

This repository contains the open source release for the Hack-a-Sat 2020
qualifier.

Released artifacts include:

* Source code for all challenges
* Source code for all challenge solutions
* Infrastructure to build all challenges and their solutions
* Notes on how to build and solve challenges

Released artifacts *do not* include:

* Infrastructure used to host and run the game
* Source code for the score board
* Source code for the "ticket taker" or "lifecycle manager" (used to host
  randomized challenges within the live game infrastructure)
* Source code for the "sat solver" (used to test challenges before deployment)


## Repository Structure ##

The infrastructure for Hack-a-Sat 2020 deployed challenges from self-contained
[Docker](https://www.docker.com/) images. Each challenge has an internal
name that is used to refer to that challenge's containers. These names are not
necessarily the same as the name that was used on the scoreboard. Folders
within this repository are named according to each challenge's internal name,
rather than its external one.

The following is a mapping of all names by category (`External: Internal`):

* Space Cadets
    * Lt. Cmdr. Data: `basic-file`
    * Lt. Starbuck: `basic-service`
    * Capt. Solo: `basic-handoff`
* Astronomy, Astrophysics, Astrometry, and Astrodynamics (AAAA)
    * I Like to Watch: `beckley`
    * Attitude Adjustment: `attitude`
    * Seeing Stars: `centroids`
    * Digital Filters, Meh: `filter`
    * SpaceBook: `spacebook`
    * My 0x20: `myspace`
* Satellite Bus
    * Magic Bus: `bus`
    * Bytes Away!: `patch`
    * Sun? On My Sat?: `sparc1`
    * Monkey in the Middle: `chagford`
    * Sun? On My Sat? Again?: `sparc2`
* Ground Segment
    * Track the Sat: `antenna`
    * Can you hear me now?: `verizon`
    * Talk to me, Goose: `goose`
    * I see what you did there: `rbs_m2`
    * Vax the Sat: `vaxthesat`
* Communication System
    * Phasors to Stun: `phasor`
    * 56K Flex Magic: `modem`
    * Phasors to Kill: `phasor2`
    * Ground Control to Major Tom: `major_tom`
    * Something's Out There: `nena`
* Payload Modules
    * That's not on my calendar: `monroe`
    * SpaceDB: `spacedb`
    * Space Race: `spacerace`
    * Leaky Crypto: `leaky`
    * LaunchLink: `rfmagic`
* Space and Things
    * Where's the Sat?: `jackson`
    * Don't Tweet That Picture: `tweet`
    * Good Plan? Great Plan!: ` mission`
    * 1201 Alarm: `apollo_gcm`
    * Rogue Base Station: `rogue`

The `qemu-sparc` folder is included to build the [qemu](https://www.qemu.org/)
emulator that was used in the two "Sun? On My Sat?" challenges.

The `rtems` folder is included to build the [RTEMS](https://www.rtems.org/)
operationg system that was used in the TODO challenges.

The `vmips-mips-emulator` folder is included to build the
[vmips](http://www.dgate.org/vmips/) emulator that was used in the
"LaunchLink" challenge.


## Building and Deploying Challenges ##

For instructions on how to build each challenge's Docker images, please refer
to each folder's `README.md`. Each challenge may have up to 3 separate images:

* `generator` - Used to generate any static files necessary to give to teams.
* `challenge` - Used to host the actual challenge on the game infrastructure.
* `solver` - Used to ensure the challenge would be solvable for a given team.

### Missing Infrastructure ###

This repository does not contain the `ticket-taker`, `lifecycle-manager`, or
`sat-solver` programs (or their source code).

During the live Hack-a-Sat 2020 qualifier, challenges were deployed with a
program called `ticket-taker`. This program would take a supplied ticket and
use it to generate a seed value and flag specific to that ticket. It would then
launch an instance of the challenge container, passing any options necessary
via environment variables.

Using `ticket-taker` posed a problem for certain challenges: External tools we
expected players to use, like Google Maps, don't understand "tickets". A
second program called `lifecycle-manager` was used for these challenges.
`ticket-taker` would launch an instance of `lifecycle-manager` to "manage" the
connection between the player and the challenge after the player authenticated
with their ticket.

The commands below are from our internal test tool (called `sat-solver`), that
was capable of testing the solver against a specific seed in a managed
environment without `ticket-taker` or `lifecycle-manager`. These commands
should be sufficient for anyone using this repository to quickly host
challenges locally for testing.

[This file](https://static.2020.hackasat.com/tickets_seeds_20200713.csv) can
be used as a "decoder ring" for turning tickets from the live event into seed
values that allow you to run the same copy of the challenge your team got in
the 2020 qualifier.

### Generators ###

These were run in a job queue prior to the release of a challenge to generate
the unique status files for each team's challenge seed:

```sh
docker run -t --rm -v <dir>:/out -e SEED=<seed> -e FLAG=<flag> <container>:generator
```

* `dir` is the output directory on the host where you want generated files
  to be stored.
* `seed` is the random seed you want files to be generated for.
* `flag` is the flag you expect the team to submit to the scoreboard.
* `container` is the internal name of the challenge (see above).

Generators were typically built off of the `generator-base` Docker image. As a
result, you'll need to build the image in the `generator-base` folder before
building any generator images.

### Challenges ###

These were run on hardened AWS VMs that were provisioned by a central
[Puppet](https://puppet.com/) Master. Every VM only hosted a single challenge.
Multiple VMs were used with a round-robin DNS loadbalancer to spread connections
across all VMs provisioned for that challenge.

Puppet would install [`xinetd`](https://en.wikipedia.org/wiki/Xinetd), which
would open up a single port for incoming connections for `ticket-taker`.
`ticket-taker` would be responsible for executing one of the commands below
based on a configuration file after the player's ticket was verified:

```sh
# use this if the challenge only needs basic options
docker run --rm -i -e SEED=<seed> -e FLAG=<flag> <container>:challenge

# use this if the challenge needs generated files to run
docker run --rm -i -e DIR=/mnt -v <dir>:/mnt -e SEED=<seed> -e FLAG=<flag> <container>:challenge

# use this if the challenge is required to have its connections managed
docker run --rm -i -e SERVICE_HOST=<host> -e SERVICE_PORT=<port> -e SEED=<seed> -e FLAG=<flag> <container>:challenge

# use this if the challenge needs both generated files and a managed connection
docker run --rm -i -e DIR=/mnt -v <dir>:/mnt -e SERVICE_HOST=<host> -e SERVICE_PORT=<port> -e SEED=<seed> -e FLAG=<flag> <container>:challenge
```

* `seed` is the random seed to use when running the challenge.
* `flag` is the flag you expect the team to submit to the scoreboard.
* `container` is the internal name of the challenge (see above).
* `host` is the IP or address of the host this container is running on.
* `port` is the additional port the challenge should open.
* `dir` is the directory on the host where generated files are stored.

To re-host these challenges *without* `xinetd`, you can use `socat` like so:

```sh
# remember to escape any colons (":") in the commands above with backslashes!
socat -v tcp-listen:<port>,reuseaddr "exec:<command from above>"
```


### Solvers ###

These were run in batches on a server with tons of cores to ensure every team
would be able to solve their randomized version of each challenge. They were
also run any time a team wanted verification that a challenge was working as
intended during the live game.

```sh
# use this if the solver only needs basic options
docker run -it --rm -e HOST=<host> -e PORT=<port> <container>:solver

# use this if the solver needs generated files to run
docker run -it --rm -e HOST=<host> -e PORT=<port> -e DIR=/mnt -v <dir>:/mnt <container>:solver

# use this if you want to solve with a specific ticket
docker run -it --rm -e HOST=<host> -e PORT=<port> -e TICKET=<ticket> <container>:solver

# use this if you want to solve with a specific ticket and need generated files
docker run -it --rm -e HOST=<host> -e PORT=<port> -e DIR=/mnt -v <dir>:/mnt -e TICKET=<ticket> <container>:solver
```

* `seed` is the random seed of the challenge you're trying to solve.
* `ticket` is the ticket for your team.
* `container` is the internal name of the challenge (see above).
* `host` is the IP or address of the challenge host.
* `port` is the port on the challenge host for this challenge.
* `dir` is the directory on the host where generated files are stored.

It should be noted that these solvers implement *a* solution for their
challenge, not *the* solution. Many challenges had alternative ways of solving
them (some easier, some harder) that were not tested by (and, in some cases, not
intended by) the organizers.


## License ##

Challenges in this repository are provided as-is under the MIT license.
See [LICENSE.md](LICENSE.md) for more details.


## Contact ##

Questions, comments, or concerns can be sent to `hackasat[at]cromulence.com`.
