# Quals Challenge: Rogue Base Station #

**Category:** Space and Things
**Relative Difficulty:** 5/5
**Author:** [Cromulence](https://cromulence.com/)

We've detected a transmission from a nearby "rogue" transmitter from an
unknown location. Help us find them so we can tell them to get off our
airwaves!


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `rogue:generator`,
`rogue:challenge`, and `rogue:solver`.

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
