#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

. checks/require VERSION TARGET_BRANCH

. vcs/commit.sh "${TARGET_BRANCH} <- ${VERSION}" "${VERSION}"
