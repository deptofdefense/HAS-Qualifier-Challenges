# Quals Challenge: Can you hear me now? #

**Category:** Ground Segment
**Relative Difficulty:** 2/5
**Author:** [Cromulence](https://cromulence.com/)

LaunchDotCom's ground station is streaming telemetry data from its Carnac 1.0
satellite on a TCP port. Implement a decoder from the XTCE definition.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `verizon:challenge` and
`verizon:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This challenge service simulates a payload providing telemetry data on a TCP
port. In the telemetry is an encoded flag.  The competitors must write a
decoder that implements the specification provided in XTCE format, and with
CCSDS doc refs.
