# Quals Challenge: I see what you did there #

**Category:** Ground Segment
**Relative Difficulty:** 4/5
**Author:** [Red Balloon Security](https://www.redballoonsecurity.com/)

Your rival seems has been tracking satellites with a hobbiest antenna,
and it's causing a lot of noise on my ground lines. Help me figure out
what he's tracking so I can see what she's tracking.


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `rbs_m2:generator`,
`rbs_m2:challenge`, and `rbs_m2:solver`.

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

Similar to Antenna, but in reverse! Determine the pointing angles of the
antenna using the calculated PWM of the recorded signals (inductive cross
talk). Figure out the three satellites that were being tracked.
