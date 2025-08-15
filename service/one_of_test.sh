#!/usr/local/bin/bash

ISSUER='checks/one_of.sh'

ACTUAL_VALUE="$($mt/${ISSUER} foo bar baz)"
. $mt/../service/assert.sh "${ISSUER}" $? 1

ACTUAL_VALUE="$($mt/${ISSUER} foo bar foo)"
. $mt/../service/assert.sh "${ISSUER}" $? 0
