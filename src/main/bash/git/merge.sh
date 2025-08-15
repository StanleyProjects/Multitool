#!/usr/local/bin/bash

. $mt/checks/require.sh SOURCE_COMMIT

git merge --no-ff --no-commit "${SOURCE_COMMIT}"

. $mt/checks/success.sh $? 'Merge error!'
