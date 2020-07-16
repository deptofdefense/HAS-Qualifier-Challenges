#!/bin/bash

# Ensure variables are set, stop the script on the first error
set -u -e
: "$MY_SERVER_NUMBER_DASHED"
: "$SOLUTION_NUMBER_AREA_CODE"

# So we have a known state for relative paths
cd `dirname "$0"`

####################################################################################################
MY_NOTE_PATH="/tmp/my_note.txt"

# Build the note using variables
(   echo "---=== MY SERVER ===---"
    echo "Phone #: $MY_SERVER_NUMBER_DASHED"
    echo "Username: hax"
    echo "Password: hunter2"
    echo ""
    echo "* Modem implements a (very small) subset of 'Basic' commands as"
    echo "  described in the ITU-T V.250 spec (Table I.2)"
    echo ""
    echo "---=== THEIR SERVER ===---"
    echo ""
    echo "Ground station IP: 93.184.216.34"
    echo "Ground station Phone #: $SOLUTION_NUMBER_AREA_CODE-XXX-XXXX ...?"
    echo "Username: ?"
    echo "Password: ?"
    echo ""
    echo "* They use the same model of modem as mine... could use +++ATH0"
    echo "  ping of death"
    echo "* It'll have an interactive login similar to my server"
    echo "* Their official password policy: minimum requirements of"
    echo "  FIPS112 (probably just numeric)"
    echo "    * TL;DR - section 4.1.1 of 'NBS Special Publication 500-137'"
    echo ""
) > "$MY_NOTE_PATH"

# Echo result so that the uploader sees it
echo "$MY_NOTE_PATH"
