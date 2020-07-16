# Quals Challenge: Seeing Stars #

**Category:** Astronomy, Astrophysics, Astrometry, and Astrodynamics (AAAA)
**Relative Difficulty:** 3/6
**Author:** [Cromulence](https://cromulence.com/)

Here is the output from a CCD Camera from a star tracker, identify as many
stars as you can! (in image reference coordinates) Note: The camera prints
pixels in the following order (x,y): (0,0), (1,0), (2,0)... (0,1), (1,1),
(2,1)...

Note that top left corner is (0,0).


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `centroid:challenge` and
`centroid:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

Basic Image Centroiding Challenge. Require teams to report calculated centroids
from randomly generated bitmaps of "stars". Bitmaps attempt to replicate basic 
physics affecting a CCD such as noise. The challenge expects results in the image
coordinate system. Additional challenge if the challenge requires results in the
boresight or body reference frame because that math is harder to get right.

This challenge requires floating point answers, so the challenge will grade the
submissions using a least squares calculation. Note: the user Teams must make an 
automated solver because they must be able to accurately centroid 10 images 
within a time limit. The challenge has configurable thresholds for accuracy, 
required points correct per trial, required trials correct out of total... etc..
