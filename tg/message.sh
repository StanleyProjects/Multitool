#!/usr/local/bin/bash

. $mt/checks/eq $# 1 'Wrong arguments!'

MESSAGE="$1"

. $mt/checks/require TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID MESSAGE

REQUEST_BODY='{parse_mode: "markdown"}'

for it in \
  '.link_preview_options.is_disabled=true' \
  ".text=\"${MESSAGE}\"" \
  ".chat_id=${TG_CHAT_ID}"; do
 REQUEST_BODY="$(echo "${REQUEST_BODY}" | yq -M -o=json "${it}")"
 . $mt/checks/success $? 'Request body error!'
done

CODE=$(curl -w %{http_code} -o /dev/null \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/sendMessage" \
 -H 'Content-Type: application/json' \
 --data "${REQUEST_BODY}")

. $mt/checks/eq $CODE 200 "Send tg message error!"
