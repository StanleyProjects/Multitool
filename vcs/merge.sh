#!/usr/local/bin/bash

. checks/require SOURCE_COMMIT

git merge --no-ff --no-commit "${SOURCE_COMMIT}"

. checks/success $? 'Merge error!'
