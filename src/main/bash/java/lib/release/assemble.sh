#!/usr/local/bin/bash

VARIANT='release'

gradle "lib:assemble${VARIANT^}Metadata" \
 && gradle "lib:assemble${VARIANT^}MavenMetadata" \
 && gradle "lib:assemble${VARIANT^}Jar" \
 && gradle "lib:assemble${VARIANT^}Source" \
 && gradle "lib:assemble${VARIANT^}Pom" \
 && gradle "lib:assemble${VARIANT^}Docs" \
 && gradle "lib:assemble${VARIANT^}Javadoc"

. $mt/checks/success.sh $? "Assemble \"${VARIANT}\" error!"

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file.sh "${ISSUER}"

ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}.pom"
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}-sources.jar"
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}-javadoc.jar"
. $mt/checks/file.sh "${ISSUER}"

ISSUER="lib/build/docs/${VARIANT}/index.html"
. $mt/checks/file.sh "${ISSUER}"
