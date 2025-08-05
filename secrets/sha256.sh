#!/usr/local/bin/bash

. $mt/checks/eq $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/require ISSUER

. $mt/checks/file "${ISSUER}"

rm "${ISSUER}.sha256"

cat "${ISSUER}" | openssl dgst -sha256 -out "${ISSUER}.sha256"

. $mt/checks/success $? "Hash \"${ISSUER}\" error!"

. $mt/checks/file "${ISSUER}.sha256"
