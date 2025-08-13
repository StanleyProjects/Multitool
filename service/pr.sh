#!/usr/local/bin/bash

mt='./scripts'

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

. $mt/../service/assemble.sh
ISSUER='.mt/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
. $mt/checks/require VERSION TARGET_BRANCH
. $mt/gh/tag/test.sh "${VERSION}"
. $mt/git/commit.sh  "${VERSION}" "${TARGET_BRANCH} <- ${VERSION}"

. $mt/../service/unit_test.sh
. $mt/../service/gh/release.sh
. $mt/../service/message.sh
