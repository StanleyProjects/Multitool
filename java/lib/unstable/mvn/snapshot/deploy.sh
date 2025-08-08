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

MVN_REPOSITORY_ID='central-portal-snapshots'

echo "
<settings>
 <servers>
  <server>
   <id>${MVN_REPOSITORY_ID}</id>
   <username>${MVN_SNAPSHOT_USER}</username>
   <password>${MVN_SNAPSHOT_PASSWORD}</password>
  </server>
 </servers>
</settings>
" > '.mt/settings.xml'

MVN_URL='https://central.sonatype.com/repository/maven-snapshots'

mvn deploy:deploy-file \
 -Duser.home='.mt'
 -Durl="${MVN_URL}" \
 -DrepositoryId="${MVN_REPOSITORY_ID}" \
 -Dfile="${ARTIFACT_FILE}" \
 -Dsources="${SOURCES_FILE}" \
 -DpomFile="${POM_FILE}"

. $mt/checks/success $? "Maven snapshot deploy error!"

rm '.mt/settings.xml'
