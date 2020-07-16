# Quals Challenge: Digital Filters, Meh #

**Category:** Astronomy, Astrophysics, Astrometry, and Astrodynamics (AAAA)
**Relative Difficulty:** 4/6
**Author:** [Cromulence](https://cromulence.com/)

Included is the simulation code for the attitude control loop for a satellite
in orbit. A code reviewer said I made a pretty big mistake that could allow a
star tracker to misbehave. Although my code is flawless, I put in some checks
to make sure the star tracker can't misbehave anyways.

Review the simulation I have running to see if a startracker can still mess
with my filter. Oh, and I'll be giving you the attitude of the physical system
as a quaternion, it would be too much work to figure out where a star tracker
is oriented from star coordinates, right?


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `filter:generator`,
`filter:challenge`, and `filter:solver`.

You can also build just one of them with `make generator`, `make challenge`,
or `make solver` respectively.

Building the `generator` container requires having already built the
`generator-base` container (see the `generator-base` folder).


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

The challenge is meant to teach about digital filters, specifically a state
estimator built with a kalman filter. The answer is not very challenging,
ramping up error over time is enough to make the system drift, even if the
filter is meant to reject sudden errors. 
