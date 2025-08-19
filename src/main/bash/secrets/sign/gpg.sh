#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 3 'Wrong arguments!'

ISSUER="$1"
GPG_KEY_ID="$2"
GPG_PASSWORD="$3"

. $mt/checks/require.sh ISSUER GPG_KEY_ID GPG_PASSWORD

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.asc" &> /dev/null

gpg --pinentry-mode loopback --passphrase "${GPG_PASSWORD}" -u "${GPG_KEY_ID}" -ab "${ISSUER}"

. $mt/checks/success.sh $? "GPG sign \"${ISSUER}\" error!"

. $mt/checks/file.sh "${ISSUER}.asc"
