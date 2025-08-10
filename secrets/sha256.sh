#!/usr/local/bin/bash

. $mt/checks/eq $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/require ISSUER

. $mt/checks/file "${ISSUER}"

rm "${ISSUER}.sha256"

HASH="$(openssl dgst -sha256 -binary "${ISSUER}" | xxd -p -c 64)"

. $mt/checks/eq 64 "${#HASH}" "Hash \"${ISSUER}\" error!"

echo "${HASH}" > "${ISSUER}.sha256"

. $mt/checks/file "${ISSUER}.sha256"
