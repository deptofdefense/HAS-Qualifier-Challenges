# Quals Challenge: Monkey in the Middle #

**Category:** Satellite Bus
**Relative Difficulty:** 4/5
**Author:** [X8](https://x8llc.com/)

We found two devices communicating on an open channel, but somehow it looks
pretty safe... We've captured the firmware update for the server side,
maybe you can find something interesting?


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `chagford:generator`,
`chagford:challenge`, and `chagford:solver`.

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
