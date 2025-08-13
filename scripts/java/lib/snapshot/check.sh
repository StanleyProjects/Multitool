#!/usr/local/bin/bash

VARIANT='snapshot'

gradle 'checkLicense' \
 && gradle 'checkCodeStyle' \
 && gradle "lib:check${VARIANT^}Readme" \
 && gradle 'lib:checkUnitTest' \
 && gradle 'lib:checkCoverage' \
 && gradle 'lib:checkCodeQuality'

. $mt/checks/success $? 'Check error!'

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
REPOSITORY_NAME="$(yq -erM .repository.name "$ISSUER")" || exit 1
REPOSITORY_VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1
ARTIFACT_VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. $mt/checks/require REPOSITORY_NAME REPOSITORY_VERSION ARTIFACT_ID ARTIFACT_VERSION

. $mt/checks/eq "${REPOSITORY_NAME}" "${ARTIFACT_ID}" \
 "Repository name is \"${REPOSITORY_NAME}\", but artifact ID is \"${ARTIFACT_ID}\"!"

. $mt/checks/eq "${REPOSITORY_VERSION}" "${ARTIFACT_VERSION}" \
 "Repository version is \"${REPOSITORY_VERSION}\", but artifact version is \"${ARTIFACT_VERSION}\"!"
