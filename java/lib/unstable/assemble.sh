#!/usr/local/bin/bash

VARIANT='unstable'

gradle "lib:assemble${VARIANT^}Metadata"

. checks/success $? "Assemble \"$VARIANT\" error!"

. checks/file 'lib/build/yml/metadata.yml'
