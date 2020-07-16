# Quals Challenge: Good Plan? Great Plan! #

**Category:** Space and Things
**Relative Difficulty:** 3/5
**Author:** [Cromulence](https://cromulence.com/)

Help the Launchdotcom team perform a mission on their satellite to
take a picture of a specific location on the ground. No hacking
here, just good old fashion mission planning!


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `mission:challenge` and
`mission:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##
