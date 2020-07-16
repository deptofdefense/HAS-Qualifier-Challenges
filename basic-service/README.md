# Quals Challenge: Lt. Starbuck #

**Category:** Space Cadets
**Relative Difficulty:** 2/3
**Author:** [Cromulence](https://cromulence.com/)

In this CTF, questions may come in one of three different flavors. The
second is a service running on an external host that has the flag on it.
Connect to the external host, give it your ticket, solve the problem it
asks of you, get the flag, and submit it to the scoreboard to score points.
Most of these questions will require you to write a program to interact
with the server in order to solve the problem within a strict time limit.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `basic-service:challenge` and
`basic-service:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This is our sample service for Hack-a-Sat, repackaged as an actual challenge.
We decided to include it in the actual game to give new players something to
test their assumptions on before actually getting to the real challenges.
