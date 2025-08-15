#!/usr/local/bin/bash

ISSUER='LICENSE'
. $asserts/file.sh "${ISSUER}"

AUTHOR='Stanley Wintergreen'
REGEX="Copyright 2[0-9]{3} ${AUTHOR}"
. $asserts/regex.sh "$(cat "${ISSUER}")" "${REGEX}"
