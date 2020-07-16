# Quals Challenge: I Like to Watch #

**Category:** Astronomy, Astrophysics, Astrometry, and Astrodynamics (AAAA)
**Relative Difficulty:** 1/6
**Author:** [X8](https://x8llc.com/)

Fire up your Google Earth Pro and brush up on your KML tutorials, we're going
to make it look at things!


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `beckley:challenge` and
`beckley:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This expects challengers to use Google Earth (Pro) to connect to a webserver
to point at a specific view of a landmark. It seems Google earth bounds the
view angle to a different range of angles than expected in some cases, `curl`
can be used to work around that which is how the solver approaches it.
