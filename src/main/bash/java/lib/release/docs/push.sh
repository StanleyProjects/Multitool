#!/usr/local/bin/bash

. $mt/checks/require.sh REPOSITORY_OWNER REPOSITORY_NAME VCS_PAT

VARIANT='release'

ISSUER="lib/build/docs/${VARIANT}/index.html"
. $mt/checks/file.sh "${ISSUER}"

DOCS_PATH='.mt/docs'
mkdir "${DOCS_PATH}"

VCS_URL="https://${VCS_PAT}@github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git"

git -C "${DOCS_PATH}" init \
 && git -C "${DOCS_PATH}" remote add origin "${VCS_URL}" \
 && git -C "${DOCS_PATH}" fetch --depth=1 origin 'gh-pages' \
 && git -C "${DOCS_PATH}" checkout 'gh-pages'

. $mt/checks/success.sh $? 'Checkout docs error!'

if [[ -f "${DOCS_PATH}/docs/${VERSION}/index.html" ]]; then
 echo 'Docs version error!'; exit 1; fi

ISSUER='.mt/gh-gpg-keys.json'
. $mt/checks/file.sh "${ISSUER}"
GPG_KEY_ID="$(yq -erM .[0].key_id "${ISSUER}")" || exit 1

ISSUER='.mt/gh-user.json'
. $mt/checks/file.sh "${ISSUER}"

USER_NAME="$(yq -erM .name "${ISSUER}")" || exit 1
USER_ID="$(yq -erM .id "${ISSUER}")" || exit 1
USER_LOGIN="$(yq -erM .login "${ISSUER}")" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

git -C "${DOCS_PATH}" config user.name "${USER_NAME}" \
 && git -C "${DOCS_PATH}" config user.email "${USER_EMAIL}" \
 && git -C "${DOCS_PATH}" config gpg.program '/usr/local/bin/gpgloopback.sh' \
 && git -C "${DOCS_PATH}" config user.signingkey "${GPG_KEY_ID}"

. $mt/checks/success.sh $? 'Config docs error!'

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

mkdir "${DOCS_PATH}/docs"
cp -r "lib/build/docs/${VARIANT}" "${DOCS_PATH}/docs/${VERSION}"

. $mt/checks/success.sh $? 'Copy docs error!'

echo 'Not implemented!'; exit 1 # todo
