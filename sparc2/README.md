# Quals Challenge: Sun? On My Sat? Again? #

**Category:** Satellite Bus
**Relative Difficulty:** 5/5
**Author:** [Cromulence](https://cromulence.com/)

After heaps of code reviews, I'm sure nobody can get to this flag, it's
not even referenced by the code!


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `sparc2:generator`,
`sparc2:challenge`, and `sparc2:solver`.

You can also build just one of them with `make generator`, `make challenge`,
or `make solver` respectively.

Building the `challenge` container requires having already built the
`qemu:sparc` container (see the `qemu-sparc` folder).

Building the `generator` and `solver` containers requires having already
build the `rtems5:tools-sparc` containers (see the `rtems` folder).

Building the `generator` container requires having already built the
`generator-base` container (see the `generator-base` folder).


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This challenge is based on a heap overflow bug built into a custom malloc
implementation, based on a typical unlink bug.
