#!/usr/local/bin/bash

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

. $mt/bash/assemble.sh
. $mt/bash/commit.sh
. $mt/bash/check.sh

echo 'Not implemented!'; exit 1

. $mt/gh/push.sh
. $mt/java/lib/unstable/mvn/deploy.sh
. $mt/java/lib/unstable/gh/release.sh
. $mt/java/lib/unstable/message.sh
