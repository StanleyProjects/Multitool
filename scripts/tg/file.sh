#!/usr/local/bin/bash

. $mt/checks/eq $# 2 'Wrong arguments!'

MESSAGE="$1"
FILE_PATH="$2"

. $mt/checks/require TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID MESSAGE FILE_PATH

. $mt/checks/file "${FILE_PATH}"

CODE=$(curl -w %{http_code} -o /dev/null \
 --form "document=@\"${FILE_PATH}\"" \
 --form "chat_id=\"${TG_CHAT_ID}\"" \
 --form "caption=\"${MESSAGE}\"" \
 --form "parse_mode=\"markdown\"" \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/sendDocument")

. $mt/checks/eq $CODE 200 "Send tg message error!"
