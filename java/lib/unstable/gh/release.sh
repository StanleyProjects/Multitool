#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. $mt/checks/require VERSION

MESSAGE="
There should be files here...
" # todo

. $mt/gh/release.sh "${VERSION}" "${MESSAGE}"

ISSUER='.mt/public.pem'
curl -f "https://${REPOSITORY_OWNER}.github.io/debug-public.pem" -o "${ISSUER}"
. $mt/checks/success $? "Get public key \"${REPOSITORY_OWNER}\" error!"
. $mt/checks/file "${ISSUER}"

# todo sign
# todo sign check
# todo upload
