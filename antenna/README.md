# Quals Challenge: Track the Sat #

**Category:** Ground Segment
**Relative Difficulty:** 1/5
**Author:** [Red Balloon Security](https://www.redballoonsecurity.com/)

You're in charge of controlling our hobbiest antenna. The antenna is controlled by
two servos, one for azimuth and the other for elevation. Included is an example
file from a previous control pattern. Track the satellite requested so we can see
what it is broadcasting.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `antenna:challenge` and
`antenna:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

Test whether a challenger can figure out how to track a satelitte across the
sky. The challenge simulates a satellite using a TLE, point the antenna by
controlling two servos.
