# Quals Challenge: Don't Tweet That Picture #

**Category:** Space and Things
**Relative Difficulty:** 2/5
**Author:** [Cromulence](https://cromulence.com/)

Here are some pictures captured by an imaging satellites. Can you figure out
where these pictures were taken from?

The 4 buildings have the same footprint and spaced perfectly around a circle,
one positioned at each cardinal direction, the tallest is located at due north.

Date format is DD-MM-YYYY.


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `tweet:generator`,
`tweet:challenge`, and `tweet:solver`.

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

This challenge is based on when the internet tried to identify a satellite
that took a picture from space of the ground.

It seems the coordinate frames are not generated in the commonly expected
way, our bad...

The pictures are all generated using a graphics tools and solved manually
by inputting picked coordinates on the images.
