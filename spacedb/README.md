# Quals Challenge: SpaceDB #

**Category:** Payload Modules
**Relative Difficulty:** 2/5
**Author:** [Cromulence](https://cromulence.com/)

The last over-the-space update seems to have broken the housekeeping on our
satellite. Our satellite's battery is low and is running out of battery fast.
We have a short flyover window to transmit a patch or it'll be lost forever.
The battery level is critical enough that even the task scheduling server has
shutdown. Thankfully can be fixed without without any exploit knowledge by
using the built in APIs provied by KubOS. Hopefully we can save this one!

Note: When you're done planning, go to low power mode to wait for the next
transmission window.


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `spacedb:challenge` and
`spacedb:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

The focus of this challenge is to gain familiarity with KubOS -- how it
delegates tasks, and its flexibility with services and mission applications.
Teams will have to learn how the telemetry and scheduler system works within
KubOS as well as carefully look through the KubOS documentation. This
challenge will be split into two parts: 

* The battery level is in the range where the system shuts off non-critical
  items to conserve power to avoid a hard shutdown. This means communication
  with the scheduler service is disabled. To re-enable the scheduler the
  thresholds for the Monitor service need to be reconfigured to allow full
  operation at this battery level. 
* The Mission application which prints the flag value to a log file, is
  set to only run a delay value only, meaning in the Kubos architecture that
  it only runs once after a reboot.  So the teams need to figure out how to
  reboot the OBC. 
