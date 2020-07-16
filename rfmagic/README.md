# Quals Challenge: LaunchLink #

**Category:** Payload Modules
**Relative Difficulty:** 5/5
**Author:** [Cromulence](https://cromulence.com/)

Satellite Internet brought to you by LaunchDotCom, first generation
prototype, ahead of its time. We've managed to download an early prototype
of their payload module. Our team of reverse engineers have analyzed the
prototype and developed a suitable emulator for executing the binary
firmware extracted from the device. We've included the Emulator and
Reverse Engineering notes from our analysis.


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `rfmagic:generator`,
`rfmagic:challenge`, and `rfmagic:solver`.

You can also build just one of them with `make generator`, `make challenge`,
or `make solver` respectively.

Building the `challenge` container requires having already built the
`vsim` container (see the `vmips-mips-emulator` folder).

Building the `generator` container requires having already built the
`generator-base` container (see the `generator-base` folder).


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

There's a bug hidden in the firmware run by the vmips emulator, if you
use it to write to a magic address it will print out the flag.
