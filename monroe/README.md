# Quals Challenge: That's not on my calendar #

**Category:** Payload Modules
**Relative Difficulty:** 1/5
**Author:** [X8](https://x8llc.com/)

Time for a really gentle introduction to cFS and Cosmos, hopefully
you can schedule time to learn it!

Build instructions:

$ ./setup.sh $ source ~/.bashrc $ rm Gemfile.lock $ bundle install

Hint: You will need to enable telemetry locally on the satellite,
the UDP forwarder will provide it to you as TCP from there.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `monroe:challenge` and
`monroe:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##
