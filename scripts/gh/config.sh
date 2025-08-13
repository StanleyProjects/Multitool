#!/usr/local/bin/bash

. $mt/checks/require VCS_PAT GPG_KEY

. $mt/checks/file "${GPG_KEY}"

gpg --batch --import "${GPG_KEY}"
. $mt/checks/success $? 'GPG import key error!'

VCS_API='https://api.github.com'

ISSUER='.mt/gh-gpg-keys.json'
curl -f "${VCS_API}/user/gpg_keys" -H "Authorization: token ${VCS_PAT}" -o "${ISSUER}"
. $mt/checks/success $? 'Get GPG keys error!'
. $mt/checks/file "${ISSUER}"
GPG_KEY_ID="$(yq -erM .[0].key_id "${ISSUER}")" || exit 1

ACTUAL_KEY_ID=($(gpg --show-keys --keyid-format long --with-colons "${GPG_KEY}" | grep sec))
. $mt/checks/eq 1 "${#ACTUAL_KEY_ID[@]}" 'Get GPG key ID error!'
ACTUAL_KEY_ID="${ACTUAL_KEY_ID[0]}"
ACTUAL_KEY_ID=(${ACTUAL_KEY_ID//:/ })
ACTUAL_KEY_ID="${ACTUAL_KEY_ID[4]}"
. $mt/checks/eq "${GPG_KEY_ID}" "${ACTUAL_KEY_ID}" 'Wrong GPG key!'

ACTUAL_KEY_ID=($(gpg --list-keys --keyid-format long --with-colons | grep pub))
. $mt/checks/eq 1 "${#ACTUAL_KEY_ID[@]}" 'Get GPG key ID error!'
ACTUAL_KEY_ID="${ACTUAL_KEY_ID[0]}"
ACTUAL_KEY_ID=(${ACTUAL_KEY_ID//:/ })
ACTUAL_KEY_ID="${ACTUAL_KEY_ID[4]}"
. $mt/checks/eq "${GPG_KEY_ID}" "${ACTUAL_KEY_ID}" 'Wrong GPG key!'

ISSUER='.mt/gh-user.json'
curl -f "${VCS_API}/user" -H "Authorization: token ${VCS_PAT}" -o "${ISSUER}"
. $mt/checks/success $? 'Get user error!'
. $mt/checks/file "${ISSUER}"

USER_NAME="$(yq -erM .name "${ISSUER}")" || exit 1
USER_ID="$(yq -erM .id "${ISSUER}")" || exit 1
USER_LOGIN="$(yq -erM .login "${ISSUER}")" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

GPG_UIDS="$(gpg --list-keys --keyid-format long --with-colons | grep uid)"
if [[ "${GPG_UIDS}" != *"<${USER_EMAIL}>"* ]]; then
 echo 'GPG email error!'; exit 1; fi

git config user.name "${USER_NAME}" \
 && git config user.email "${USER_EMAIL}" \
 && git config gpg.program '/usr/local/bin/gpgloopback.sh' \
 && git config user.signingkey "${GPG_KEY_ID}"

. $mt/checks/success $? 'Config error!'
