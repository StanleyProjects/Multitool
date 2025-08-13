#!/usr/local/bin/bash

. $mt/checks/eq $# 2 'Wrong arguments!'

ISSUER="$1"
KEY="$2"

. $mt/checks/require ISSUER KEY

. $mt/checks/file "${KEY}"

. $mt/checks/file "${ISSUER}"
. $mt/checks/file "${ISSUER}.sig"

openssl dgst -sha512 -verify "${KEY}" -signature "${ISSUER}.sig" "${ISSUER}"

. $mt/checks/success $? "Verify \"${ISSUER}\" error!"
