#!/usr/local/bin/bash

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME SOURCE_COMMIT TARGET_BRANCH VCS_PAT

VCS_URL="https://${VCS_PAT}@github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git"

git init \
 && git remote add origin "${VCS_URL}" \
 && git fetch origin "${TARGET_BRANCH}" \
 && git fetch origin "${SOURCE_COMMIT}" \
 && git switch "${TARGET_BRANCH}"

. $mt/checks/success $? 'Checkout error!'
