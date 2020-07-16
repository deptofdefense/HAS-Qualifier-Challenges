# Quals Challenge: Magic Bus #

**Category:** Satellite Bus
**Relative Difficulty:** 1/5
**Author:** [Cromulence](https://cromulence.com/)

There's a very busy bus we've tapped a port onto, surely there is some juicy
information hidden in the device memory... somewhere...


## Building ##

This repository contains two Docker images: The `challenge` and the `solver`.
You can build both with:

```sh
make build
```

The resulting Docker images will be tagged as `bus:challenge` and
`bus:solver`.

You can also build just one of them with `make challenge` or `make solver`
respectively.


## Deploying ##

See top-level `README.md` file for more information on deploying the
`challenge` container.


## Testing ##

See top-level `README.md` file for more information on using the `solver`
container.


## Notes ##

This challenge runs for two minutes and simulates an I2C bus with the
following devices attached:

* OBC (Onboard computer - bus master)
* EEP (Some kind of device which contains "juicy data" + the flag)
* EPS (Electrical power system controller)

The OBC, while on, polls the bus every ten seconds, providing clues, and 
generally tying up the bus most of the time. The bus data rate is 
artificially limited to ensure this.

We need to dump the EEP, but there are two problems:

1) EEP power is turned off between updates.
2) The OBC is tying up the bus most of the time.

By looking at the traffic, we see the OBC enabling power to the device,
reading from it (in random areas that don't contain the flag), and
turning it off afterwards. After that, there's a short pause
(a few seconds) before the polling starts again.

Ideally, the contestant will use that pause to issue I2C requests to
turn off the power to the OBC, freeing up the bus so the EEP can
be dumped in the time allotted.

At regular intervals in the EEP are strings saying `Juicy Data XX` where
XX is an increasing number.  Also in the EEP is a null-terminated string
which reads `THE_FLAG_IS:"..."`

The EPS memory space comprises seven four-byte values. The first are
active-high control bits indicating which power rails are turned on.
Bit 0 corresponds to rail 0, etc. The rest are float values indicating
the current voltages of rails 0 through 5, respectively. If
the rail is turned off, the voltage will be close to zero.

Things that are randomized based on the challenge container's SEED
environment variable:

* I2C slave addresses of EPS and EEP
* Location of challenge flag in the EEP
* Order of the power rails in the EPS

The input / output format is a text representation of
what happens on the bus, e.g.

`^a1+00+00+3f+.`

Where `^.` are control characters, `+-` are status flags, and the rest are
octets.

Control:
* `^` = I2C bus START
* `.` = I2C STOP

Status:
* `+` = ACK from a slave device
* `-` = NAK from a slave device

Note that the first octet after a START is a slave device address,
where the high seven bits choose the slave, and the low bit indicates
whether we wish to READ or WRITE.

If the provided slave address matches a device on the bus, an ACK `+` will
appear after the input. Else a `-` will appear.

The next two octets are a 16-bit big-endian address in the slave's memory.

After that, some indeterminate number of octets are sent:

For a WRITE, the sent octets are written to the device starting with the
specified address, and those same octets appear in the output, each followed
by ACK's, or in the case of out-of-bounds, NAK's.

For a READ, dummy octets are sent. For each one, the output will be the
next byte that's read followed by ACK. If the read is out-of-bounds, the
output will instead show the value of the dummy byte followed by a NAK.
