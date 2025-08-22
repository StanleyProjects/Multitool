#!/usr/local/bin/bash

. $mt/checks/require.sh VCS_PAT GPG_PASSWORD MVN_USER MVN_PASSWORD

VCS_API='https://api.github.com'

ISSUER='.mt/gh-gpg-keys.json'
curl -f "${VCS_API}/user/gpg_keys" -H "Authorization: token ${VCS_PAT}" -o "${ISSUER}"
. $mt/checks/success.sh $? 'Get GPG keys error!'
. $mt/checks/file.sh "${ISSUER}"
GPG_KEY_ID="$(yq -erM .[0].key_id "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
GROUP_ID="$(yq -erM .repository.groupId "${ISSUER}")" || exit 1
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1
MVN_GROUP="${GROUP_ID//.//}"

ARTIFACT_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"
SOURCES_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}-sources.jar"
POM_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}.pom"
JAVADOC_FILE="lib/build/libs/${ARTIFACT_ID}-${VERSION}-javadoc.jar"

for it in \
 "${POM_FILE}" \
 "${ARTIFACT_FILE}" \
 "${SOURCES_FILE}" \
 "${JAVADOC_FILE}"; do
 . $mt/checks/file.sh            "${it}"
 . $mt/secrets/sha1.sh           "${it}"
 . $mt/secrets/md5.sh            "${it}"
 . $mt/secrets/sign/gpg.sh       "${it}" "${GPG_KEY_ID}" "${GPG_PASSWORD}"
 . $mt/secrets/sign/gpg/check.sh "${it}" "${GPG_KEY_ID}"
done

rm -rf '.excluded/mvn'
mkdir -p ".excluded/mvn/${MVN_GROUP}/${ARTIFACT_ID}"

cp -r 'lib/build/libs' ".excluded/mvn/${MVN_GROUP}/${ARTIFACT_ID}/${VERSION}"
. $mt/checks/success.sh $? 'Copy error!'

DIR="$(pwd)"
cd '.excluded/mvn'; zip -r "${ARTIFACT_ID}-${VERSION}.zip" *; cd "${DIR}"

MVN_URL='https://central.sonatype.com'

PUB_TYPE='AUTOMATIC'
TOKEN="$(printf "${MVN_USER}:${MVN_PASSWORD}" | base64)"

curl -f -X POST -o /dev/null \
 -H "Authorization: Bearer ${TOKEN}" \
 --form bundle=@".excluded/mvn/${ARTIFACT_ID}-${VERSION}.zip" \
 "${MVN_URL}/api/v1/publisher/upload?name=${VERSION}&publishingType=${PUB_TYPE}"

. $mt/checks/success.sh $? "Maven deploy ${ARTIFACT_ID}-${VERSION} error!"

echo "${MVN_URL}/artifact/${GROUP_ID}/${ARTIFACT_ID}/${VERSION}"
