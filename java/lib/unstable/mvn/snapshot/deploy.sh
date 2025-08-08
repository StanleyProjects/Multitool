#!/usr/local/bin/bash

. $mt/checks/require MVN_SNAPSHOT_USER MVN_SNAPSHOT_PASSWORD

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1

ARTIFACT_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"
. $mt/checks/file "${ARTIFACT_FILE}"

SOURCES_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}-sources.jar"
. $mt/checks/file "${SOURCES_FILE}"

POM_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}.pom"
. $mt/checks/file "${POM_FILE}"

MVN_URL='https://central.sonatype.com/repository/maven-snapshots'

mvn deploy:deploy-file \
 -DrepositoryId='central-portal-snapshots' \
 -Drepo.username="${MVN_SNAPSHOT_USER}" \
 -Drepo.password="${MVN_SNAPSHOT_PASSWORD}" \
 -Durl="${MVN_URL}" \
 -Dfile="${ARTIFACT_FILE}" \
 -Dsources="${SOURCES_FILE}" \
 -DpomFile="${POM_FILE}"

. $mt/checks/success $? "Maven snapshot deploy error!"
