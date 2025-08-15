#!/usr/local/bin/bash

ISSUER='scripts/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. $mt/checks/require VERSION TARGET_BRANCH

. $mt/gh/tag/test.sh "${VERSION}"

. $mt/git/commit.sh "${VERSION}" "${TARGET_BRANCH} <- ${VERSION}"
