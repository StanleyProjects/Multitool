#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 3 'Wrong arguments!'

KEYSTORE_TYPE='pkcs12'
ISSUER="$1"
KEYSTORE="$2"
KEYSTORE_PASSWORD="$3"

. $mt/checks/require.sh ISSUER KEYSTORE KEYSTORE_PASSWORD KEYSTORE_TYPE

. $mt/checks/file.sh "${KEYSTORE}"

openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -checkend 0

. $mt/checks/success.sh $? "Check \"${KEYSTORE}\" error!"

. $mt/checks/file.sh "${ISSUER}"

. $mt/checks/file.sh "${ISSUER}.sig"

openssl dgst -sha512 -verify <(
  openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -pubkey -noout
 ) -signature "${ISSUER}.sig" "${ISSUER}"

. $mt/checks/success.sh $? "Verify \"${ISSUER}\" error!"
