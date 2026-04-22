#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.sha1" &> /dev/null

openssl dgst -sha1 -binary "${ISSUER}" | xxd -p -c 64 > "${ISSUER}.sha1"

HEX="$(cat "${ISSUER}.sha1")"

. $mt/checks/eq.sh 40 "${#HEX}" "Hash \"${ISSUER}\" error!"
