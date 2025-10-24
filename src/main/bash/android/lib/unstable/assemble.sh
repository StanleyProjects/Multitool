#!/usr/local/bin/bash

VARIANT='unstableDebug'

gradle "lib:assemble${VARIANT^}Metadata" \
 && gradle "lib:assemble${VARIANT^}MavenMetadata" \
 && gradle "lib:assemble${VARIANT^}" \
 && gradle "lib:assemble${VARIANT^}Source" \
 && gradle "lib:assemble${VARIANT^}Pom"

. $mt/checks/success.sh $? "Assemble \"$VARIANT\" error!"

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file.sh "${ISSUER}"

ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/outputs/aar/${ARTIFACT_ID}-${VERSION}.aar"
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/sources/${VARIANT}/${ARTIFACT_ID}-${VERSION}-sources.jar"
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/xml/${VARIANT}/${ARTIFACT_ID}-${VERSION}.pom"
. $mt/checks/file.sh "${ISSUER}"
