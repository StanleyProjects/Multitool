#!/usr/local/bin/bash

. $mt/gh/check/rates.sh

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

. $mt/java/lib/release/assemble.sh
. $mt/java/lib/commit.sh
. $mt/java/lib/release/check.sh

. $mt/gh/push.sh

. $mt/java/lib/release/docs/push.sh
. $mt/java/lib/release/mvn/deploy.sh
. $mt/java/lib/release/gh/release.sh
. $mt/java/lib/release/message.sh
