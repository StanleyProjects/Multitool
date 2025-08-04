#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
REPOSITORY_OWNER="$(yq -erM .repository.owner "$ISSUER")" || exit 1
REPOSITORY_NAME="$(yq -erM .repository.name "$ISSUER")" || exit 1
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME VERSION VCS_PAT

REP_URL="https://api.github.com/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
VCS_URL="${REP_URL}/releases/tags/${VERSION}"
CODE="$(curl -s -w %{http_code} -o /dev/null "${VCS_URL}")"
. $mt/checks/ne $CODE 200 "Release \"${VERSION}\" exists!"
. $mt/checks/eq $CODE 404 "Deploy \"${VERSION}\" error!"

VCS_URL="${REP_URL}/git/refs/tags/${VERSION}"
VCS_TAG="$(curl -f "${VCS_URL}")"
. $mt/checks/success $? "Get tag \"${VERSION}\" error!"
. $mt/checks/filled "${VCS_TAG}" 'Tag is empty!'

TAG_SHA="$(echo "${VCS_TAG}" | yq -erM .object.sha)" || exit 1
. $mt/checks/filled "${TAG_SHA}" 'Tag SHA is empty!'

MESSAGE='test' # todo

REQUEST_BODY="{
\"name\":             \"${VERSION}\",
\"tag_name\":         \"${VERSION}\",
\"target_commitish\": \"${TAG_SHA}\",
\"body\":             \"${MESSAGE}\",
\"draft\": false, \"prerelease\": true}"

VCS_URL="${REP_URL}/releases"
RELEASE="$(curl -f \
 -X POST "${VCS_URL}" \
 -H "Authorization: token ${VCS_PAT}" \
 -d "${REQUEST_BODY}")"

. $mt/checks/success $? "Release \"${VERSION}\" error!"
. $mt/checks/filled "${RELEASE}" 'Release is empty!'

PUBLIC_KEY="$(curl -f "https://${REPOSITORY_OWNER}.github.io/debug-public.pem")"
. $mt/checks/success $? "Get public key \"${REPOSITORY_OWNER}\" error!"

# todo sign
# todo sign check
# todo upload

echo "https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/releases/tag/${VERSION}"
