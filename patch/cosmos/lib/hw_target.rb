###############################################################################
# Hardware Target
#
# Notes:
#   1. Currently written to support a single target
# 
# License
#   Written by David McComas, licensed under the copyleft GNU General Public
#   License (GPL).
#
###############################################################################

require "erb"

module HwTarget

  # This needs to be set based on the flight processor architecture
  # For cosmos to actually pick up this change, you have to edit a file
  # in the targets directory, such that it re-renders all the cmd/tlm definitions
  # upon starup. Otherwise it doesn't detect the change from this library and the
  # files aren't changed on startup.
  PROCESSOR_ENDIAN = "LITTLE_ENDIAN"
   
  CPU_ADDR_SIZE = 4
   
end # module HwTarget

