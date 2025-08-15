#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 2 'Wrong arguments!'

ISSUER="$1"
KEY="$2"

. $mt/checks/require.sh ISSUER KEY

. $mt/checks/file.sh "${KEY}"

. $mt/checks/file.sh "${ISSUER}"
. $mt/checks/file.sh "${ISSUER}.sig"

openssl dgst -sha512 -verify "${KEY}" -signature "${ISSUER}.sig" "${ISSUER}"

. $mt/checks/success.sh $? "Verify \"${ISSUER}\" error!"
