#!/usr/local/bin/bash

. $mt/checks/require SOURCE_COMMIT

git merge --no-ff --no-commit "${SOURCE_COMMIT}"

. $mt/checks/success $? 'Merge error!'
