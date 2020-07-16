#!/bin/bash

gcc -o cfs-wrapper cfs-wrapper.c
make distclean
make prep
make install
