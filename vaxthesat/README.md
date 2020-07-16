# Quals Challenge: Vax the Sat #

**Category:** Ground Segment
**Relative Difficulty:** 5/5
**Author:** [Red Balloon Security](https://www.redballoonsecurity.com/)

It's still the 70's in my ground station network, login to it and see if you
can get a flag from it.


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `vaxthesat:generator`,
`vaxthesat:challenge`, and `vaxthesat:solver`.

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

In order to make the challenge and generator Dockers as fast as possible, we
have precompiled 100 variants of `server.exe`. The application that the
SERVER in the challenge Docker runs. We have also generated 100 matching
assembly files of this server application, `server.mar`.

Note that the Docker build commands access resources from the `python` and
`assets` directories in this directory.

### generator ###
The `make generate` recipe:
- selects a disassembly file, `server.mar`, baed on the `SEED` env var
- copies this file to the `DIR` env var
- prints the destiation path of the copied file: ex, `/tmp/server.mar`

The `server.mar` file seleved by this recipe matches the `server.exe`
selected by the challenge Docker container with the same `SEED` env var.

### challenge ###
The `make challenge` recipe selects a server application, `server.exe`,
based on the `SEED` environment variable. It then compiles the SERVER,
launches the SERVER, and launches the CLIENT. After the CLIENT is launched,
the participant is able to interact with it over standard in and out.

### solve ###
The `make solve` recipe solves the challenge interatively with the
`challenge` Docker container and prints the client screen containing the flag.

The solver Docker container expects a `SEED` environment variable which
corresponds to the `SEED` variable that was passed to the challenge Docker
container that it is solving.
