#!/usr/local/bin/bash

ISSUER='./assemble.sh'
. $mt/checks/file.sh "${ISSUER}"
${ISSUER}
. $mt/checks/success.sh $? 'Assemble error!'

ISSUER='build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"

VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

ISSUER="build/zip/${REP_NAME}-${VERSION}.zip"
. $mt/checks/file.sh "${ISSUER}"
