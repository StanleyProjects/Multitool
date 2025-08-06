#!/usr/local/bin/bash

. $mt/checks/eq $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/require ISSUER

. $mt/checks/file "${ISSUER}"

rm "${ISSUER}.sha256"

cat "${ISSUER}" | openssl dgst -sha256 -binary | xxd -p -c 64 > "${ISSUER}.sha256"

. $mt/checks/success $? "Hash \"${ISSUER}\" error!"

. $mt/checks/file "${ISSUER}.sha256"

HASH="$(cat "${ISSUER}.sha256")"

. $mt/checks/eq 64 "${#HASH}" "Check hash \"${ISSUER}\" error!" # todo
