#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 2 'Wrong arguments!'

ISSUER="$1"
GPG_KEY_ID="$2"

. $mt/checks/require.sh ISSUER GPG_KEY_ID

. $mt/checks/file.sh "${ISSUER}"
. $mt/checks/file.sh "${ISSUER}.asc"

gpg --verify -u "${GPG_KEY_ID}" "${ISSUER}.asc"

. $mt/checks/success.sh $? "GPG verify \"${ISSUER}\" error!"
