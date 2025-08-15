#!/usr/local/bin/bash

ISSUER='./assemble.sh'
. $mt/checks/file "${ISSUER}"
${ISSUER}
. $mt/checks/success $? 'Assemble error!'

ISSUER='scripts/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"

VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

ISSUER="scripts/build/zip/${REP_NAME}-${VERSION}.zip"
. $mt/checks/file "${ISSUER}"
