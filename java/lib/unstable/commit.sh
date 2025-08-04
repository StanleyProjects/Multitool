#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. $mt/checks/require VERSION TARGET_BRANCH

. $mt/vcs/tag/test.sh "${VERSION}"

. $mt/vcs/commit.sh "${TARGET_BRANCH} <- ${VERSION}" "${VERSION}"
