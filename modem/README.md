# Quals Challenge: 56K Flex Magic #

**Category:** Communication System
**Relative Difficulty:** 2/5
**Author:** [Red Balloon Security](https://www.redballoonsecurity.com/)

Good job! You succeeded in killing the internet connection for a ground
station. Unfortunately, it looks like they still have dial-up as a last
resort for situations like these, and are currently dialed out to their
ISP for internet access (they can still do that?). Even worse - you also
killed your own internet connection while you were at it. From behind
your landline and (very basic) dial-up modem, can you dial in to the
ground station's network to more permanently take it offline?

An anonymous source gave you an audio recording. They said PPP isn't
enabled for dial-in any more (it's an interactive login now), but that
this recording may be useful enough in itself...


## Building ##

This repository contains three Docker images: The `generator`, `challenge`,
and `solver`. You can build them all with:

```sh
make build
```

The resulting Docker images will be tagged as `modem:generator`,
`modem:challenge`, and `modem:solver`.

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

Hint 1: You may find a skim of the (short) ITU-T V.21 spec and RFC 2433
(especially section B.2) useful. And is there any way to use AT commands
on your modem while still connected to a target?

Hint 2: Useful text: +++ATH0, _get_NTLMv1_response
