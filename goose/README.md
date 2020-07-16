# Quals Challenge: Talk to me, Goose #

**Category:** Ground Segment
**Relative Difficulty:** 3/5
**Author:** [Cromulence](https://cromulence.com/)

LaunchDotCom has a new satellite, the Carnac 2.0. What can you do with it
from its design doc?


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `goose:challenge` and
`goose:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This challenge service simulates a payload providing telemetry data and
taking commands on a TCP port. In the telemetry is an encoded flag but the
function generating the flag is disabled by command. The competitors must
write a C2 in COSMOS that implements the telemetry and command specification
provided in XTCE format, and with CCSDS doc refs. Step one will be to send
commands to re-enable the power to the flag generator and possibly other
steps to cause flags to be transmitted.
