#!/usr/local/bin/bash

VARIANT='unstable'

gradle "lib:assemble${VARIANT^}Metadata" \
 && gradle "lib:assemble${VARIANT^}MavenMetadata" \
 && gradle "lib:assemble${VARIANT^}Jar" \
 && gradle "lib:assemble${VARIANT^}Source"

. $mt/checks/success $? "Assemble \"$VARIANT\" error!"

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"

ARTIFACT_ID="$(yq -e .repository.artifactId "${ISSUER}")" || exit 1
VERSION="$(yq -e .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"

. $mt/checks/eq "${VERSION}" "$(yq -erM .version "${ISSUER}")" 'Version error!'

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"
. $mt/checks/file "${ISSUER}"

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}-sources.jar"
. $mt/checks/file "${ISSUER}"
