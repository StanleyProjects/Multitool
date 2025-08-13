#!/usr/local/bin/bash

mt='./scripts'

mkdir '.mt'

ISSUER='.mt/metadata.yml'

$mt/../service/metadata.sh > "${ISSUER}"
. $mt/checks/eq $? 0 'Read metadata error!'

VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

ISSUER=".mt/${REP_NAME}-${VERSION}.zip"
zip -r "${ISSUER}" scripts LICENSE README.md
