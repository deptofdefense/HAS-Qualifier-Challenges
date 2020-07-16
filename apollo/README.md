# Quals Challenge: 1201 Alarm #

**Category:** Space and Things
**Relative Difficulty:** 4/5
**Author:** Astronautic Security

Step right up, here's one pulled straight from the history books. See if
you can DSKY your way through this challenge! (Thank goodness VirtualAGC
is a thing...)


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `apollo:challenge` and
`apollo:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This challenge is about understanding the AGC from the open source project
designed to emulate it. The challenge modifies one of the constants in
memory, and slides it around a tiny bit. The challengers are expected to
use simulated DSKY to control the AGC to poke around in memory and
find the changed value.
