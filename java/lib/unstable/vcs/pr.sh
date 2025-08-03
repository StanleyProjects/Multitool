#!/usr/local/bin/bash

. checks/require REPOSITORY_OWNER REPOSITORY_NAME SOURCE_COMMIT VCS_PAT

VARIANT='unstable'
TARGET_BRANCH="${VARIANT}"

VCS_URL="https://${VCS_PAT}@github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git"

git init \
 && git remote add origin "${VCS_URL}" \
 && git fetch origin "${TARGET_BRANCH}" \
 && git fetch origin "${SOURCE_COMMIT}" \
 && git switch "${TARGET_BRANCH}"

. checks/success $? 'Checkout error!'

GITHUB_USER="$(curl -f 'https://api.github.com/user' -H "Authorization: token $VCS_PAT")"
. checks/success $? 'Get user error!'
. checks/filled "$GITHUB_USER" 'User is empty!'

USER_NAME="$(echo "$GITHUB_USER" | yq -erM .name)" || exit 1
USER_ID="$(echo "$GITHUB_USER" | yq -erM .id)" || exit 1
USER_LOGIN="$(echo "$GITHUB_USER" | yq -erM .login)" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

git config user.name "${USER_NAME}" \
 && git config user.email "${USER_EMAIL}"

. checks/success $? 'Config error!'

git merge --no-ff --no-commit "${SOURCE_COMMIT}"

. checks/success $? 'Merge error!'

${VARIANT}/metadata/assemble.sh \
 && ${VARIANT}/vcs/commit.sh \
 && ${VARIANT}/check.sh

. checks/success $? 'Pipeline error!'

git push && git push --tag

. checks/success $? 'Push error!'
