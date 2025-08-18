#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.sha1" &> /dev/null

HASH="$(openssl dgst -sha1 -binary "${ISSUER}" | xxd -p -c 64)"

. $mt/checks/eq.sh 40 "${#HASH}" "Hash \"${ISSUER}\" error!"

echo "${HASH}" > "${ISSUER}.sha1"

. $mt/checks/file.sh "${ISSUER}.sha1"
