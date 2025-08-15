#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/require.sh ISSUER

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.sha256"

HASH="$(openssl dgst -sha256 -binary "${ISSUER}" | xxd -p -c 64)"

. $mt/checks/eq.sh 64 "${#HASH}" "Hash \"${ISSUER}\" error!"

echo "${HASH}" > "${ISSUER}.sha256"

. $mt/checks/file.sh "${ISSUER}.sha256"
