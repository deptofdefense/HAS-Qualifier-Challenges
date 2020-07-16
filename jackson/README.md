# Quals Challenge: Where's the Sat? #

**Category:** Space and Things
**Relative Difficulty:** 1/5
**Author:** [X8](https://x8llc.com/)

Let's start with an easy one, I tell you where I'm looking at a satellite,
you tell me where to look for it later.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `jackson:challenge` and
`jackson:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

Figure out which satellite is being observed from a set of TLEs, and then
propogate it forward to prove you got it right.

Recommended hints are:

1. Consider utilizing a python module to problematically solve the puzzle.
2. Potentially consider utilizing the skyfield library specifically.
