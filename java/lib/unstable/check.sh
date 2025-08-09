#!/usr/local/bin/bash

VARIANT='unstable'

gradle 'checkLicense' \
 && gradle 'checkCodeStyle' \
 && gradle "lib:check${VARIANT^}Readme"

. $mt/checks/success $? 'Check error!'

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
REPOSITORY_NAME="$(yq -erM .repository.name "$ISSUER")" || exit 1
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1
MAVEN_VERSION="$(yq -e .project.version "${ISSUER}")" || exit 1

. $mt/checks/require REPOSITORY_NAME VERSION ARTIFACT_ID MAVEN_VERSION

. $mt/checks/eq "${REPOSITORY_NAME}" "${ARTIFACT_ID}" \
 "Repository name is \"${REPOSITORY_NAME}\", but artifact ID is \"${ARTIFACT_ID}\"!"

. $mt/checks/eq "${VERSION}" "${MAVEN_VERSION}" \
 "Repository version is \"${VERSION}\", but Maven artifact version is \"${MAVEN_VERSION}\"!"
