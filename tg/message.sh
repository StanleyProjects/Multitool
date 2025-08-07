#!/usr/local/bin/bash

. $mt/checks/eq $# 1 'Wrong arguments!'

MESSAGE="$1"

. $mt/checks/require TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID MESSAGE

MESSAGE="${MESSAGE//"#"/"%23"}"
MESSAGE="${MESSAGE//$'\n'/"%0A"}"
MESSAGE="${MESSAGE//$'\r'/""}"
MESSAGE="${MESSAGE//"_"/"\_"}"

CODE=$(curl -w %{http_code} -o /dev/null \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/sendMessage" \
 -d chat_id="${TG_CHAT_ID}" \
 -d text="${MESSAGE}" \
 -d parse_mode=markdown)

. $mt/checks/eq $CODE 200 "Send tg message error!"
