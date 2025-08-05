#!/usr/local/bin/bash

. $mt/checks/eq $# 3 'Wrong arguments!'

KEYSTORE_TYPE='pkcs12'
ISSUER="$1"
KEYSTORE="$2"
KEYSTORE_PASSWORD="$3"

. $mt/checks/require ISSUER KEYSTORE KEYSTORE_PASSWORD KEYSTORE_TYPE

. $mt/checks/file "${KEYSTORE}"

openssl "$KEYSTORE_TYPE" -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -checkend 0

. $mt/checks/success $? "Check \"${KEYSTORE}\" error!"

. $mt/checks/file "${ISSUER}"

. $mt/checks/file "${ISSUER}.sig"

openssl dgst -sha512 -verify <(
  openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -pubkey -noout
 ) -signature "${ISSUER}.sig" "${ISSUER}"

. $mt/checks/success $? "Verify \"${ISSUER}\" error!"
