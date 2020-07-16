#!/bin/bash

qemu-system-sparc -no-reboot -nographic -M leon3_generic -m 64M -kernel $1 -s -S 
