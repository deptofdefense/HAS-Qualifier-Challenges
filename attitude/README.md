# Quals Challenge: Attitude Adjustment #

**Category:** Astronomy, Astrophysics, Astrometry, and Astrodynamics (AAAA)
**Relative Difficulty:** 2/6
**Author:** [Cromulence](https://cromulence.com/)

Our star tracker has collected a set of boresight reference vectors, and
identified which stars in the catalog they correspond to. Compare the
included catalog and the identified boresight vectors to determine what our
current attitude is.

Note: The catalog format is unit vector (X,Y,Z) in a celestial reference
frame and the magnitude (relative brightness).


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `attitude:generator`,
`attitude:challenge`, and `attitude:solver`.

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

This challenge provides the user a list of boresight reference 3d vectors and
the corresponding catalog reference vectors, this is essentially a matrix alg
challenge. The goal of the challenge is provide the attitude of the boresight
from this pairing of vectors.

The example solver essentially performs an SVD to solve for the 
rotation between the two reference frames.

This could be made more challenging with more noise or mismatches. This is not 
a very difficult challenge if you know the approach, and is fairly trivial to
Google.
