#!/usr/local/bin/bash

. $mt/gh/check/rates.sh

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

. $mt/bash/assemble.sh
. $mt/bash/commit.sh
. $mt/bash/check.sh

. $mt/gh/push.sh
. $mt/bash/gh/release.sh
. $mt/bash/message.sh
