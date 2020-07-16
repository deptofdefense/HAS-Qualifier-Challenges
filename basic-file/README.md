# Quals Challenge: Lt. Cmdr. Data #

**Category:** Space Cadets
**Relative Difficulty:** 1/3
**Author:** [Cromulence](https://cromulence.com/)

In this CTF, questions may come in one of three different flavors.
The first is a downloadable file that contains the flag somewhere within it.
Download the file, extract the flag, and submit it to the scoreboard to score
points. It's that easy! (This time.)


## Building ##

This repository contains two Docker images: The `generator` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `basic-file:generator` and
`basic-file:solver`.

You can also build just one of them with `make generator` or `make solver`
respectively.

Building the `generator` container requires having already built the
`generator-base` container (see the `generator-base` folder).


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This is a basic "sanity check" service for players. All they have to do is
download the generated file, untar it, and put the flag in the scoreboard.
For people that have never seen a CTF before, this should be a good example
of how flag submission works. It's also a good way to test our generator
infrastructure.
