#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. $mt/checks/require.sh VERSION TARGET_BRANCH

. $mt/gh/tag/test.sh "${VERSION}"

. $mt/vcs/commit.sh "${VERSION}" "${TARGET_BRANCH} <- ${VERSION}"
