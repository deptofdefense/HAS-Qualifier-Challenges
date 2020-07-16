# Quals Challenge: Capt. Solo #

**Category:** Space Cadets
**Relative Difficulty:** 3/3
**Author:** [Cromulence](https://cromulence.com/)

In this CTF, questions may come in one of three different flavors. The third
is a service running on an external host that will instruct you to connect to
a different external host, usually with a program installed on your computer.
Connect to the first host, give it your ticket, get the connection string,
connect to the second host, solve the problem it asks of you, get the flag,
and submit it to the scoreboard to score points. You will only have a short
amount of time to be connected to either server, so programming may be
required.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `basic-handoff:challenge` and
`basic-handoff:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This is a simple service that runs on a fixed port within a container.
We've included it as a challenge in the actual game to get players used to
the idea that they may need to issue two separate connections for a single
challenge. In this case, they simply need to navigate to a specific URL in
their browser to retrieve the flag.
