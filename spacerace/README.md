# Quals Challenge: Space Race #

**Category:** Payload Modules
**Relative Difficulty:** 3/5
**Author:** [Cromulence](https://cromulence.com/)

LaunchDotCom's Carnac 3.0 flight software is communicating over a TCP port but
all you have is its comms-service binary to figure out its protocol and how it
works. Maybe it has a flaw you can exploit.


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `spacerace:generator`,
`spacerace:challenge`, and `spacerace:solver`.

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

Rust + KubOS challenge, there's a race condition built into the threading.
