# Quals Challenge: Sun? On My Sat? #

**Category:** Satellite Bus
**Relative Difficulty:** 3/5
**Author:** [Cromulence](https://cromulence.com/)

We've uncovered a strange device listening on a port I've connected you to on
our satellite. At one point one of our engineers captured the firmware from
it but says he saw it get patched recently. We've tried to communicate with
it a couple times, and seems to expect a hex-encoded string of bytes, but all
it has ever sent back is complaints about cookies, or something. See if you
can pull any valuable information from the device and the cookies we bought
to bribe the device are yours!


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `sparc1:generator`,
`sparc1:challenge`, and `sparc1:solver`.

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

This challenge presents teams with a basic messaging protocol to talk to a SPARC
RTEMS application. They will be provided with the binary (without a real flag). 
They are expected to find a vulnerability, find a way to land it, and then craft
a specific message to print out the Flag that normally is not accessible to them.

The actual vulnerability is SPARC architecture specific, and will require at least
a decent understanding of how a SPARC processor and instructions work. Teams 
will need to look at assembly to land the bug. There's a decent chance decompilers
will *hide* the vulnerablity.

There are plenty of ways this could be made harder if needed.

Randomization is a bit weak, it comes down to a random cookie per team, but a 
general solver is an expected part of the solution... There ARE ways to make it 
more random, but still doesn't significantly increase work load for a generic 
solver.

Qemu seems to be a bit inconsistent currently, it seems like it's made worse by
heavy work loads. I can run multiple instances of solver:challenge pairs in 
different terminals on the same linux VM and it seems like they have correlated
timeouts. It seems like it works well over 95% of the time (usually 98%+) but 
not totally clear what actually is causing the random failures. Likely
won't be a problem when run on dedicated AWS VMs? Hopefully...?
