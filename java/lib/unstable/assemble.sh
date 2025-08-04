#!/usr/local/bin/bash

VARIANT='unstable'

gradle "lib:assemble${VARIANT^}Metadata"

. $mt/checks/success $? "Assemble \"$VARIANT\" error!"

. $mt/checks/file 'lib/build/yml/metadata.yml'
