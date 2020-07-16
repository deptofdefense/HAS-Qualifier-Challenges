# Quals Challenge: Bytes Away! #

**Category:** Satellite Bus
**Relative Difficulty:** 2/5
**Author:** [Cromulence](https://cromulence.com/)

We have an encrypted telemetry link from one of our satellites but we seem
to have lost the encryption key. Thankfully we can still send unencrypted
commands using our Cosmos interface (included). I've also included the last
version of `kit_to.so` that was updated to the satellite. Can you help us
restore communication with the satellite so we can see what error "flag" is
being transmitted?


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `patch:generator`,
`patch:challenge`, and `patch:solver`.

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
