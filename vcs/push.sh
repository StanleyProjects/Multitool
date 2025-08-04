#!/usr/local/bin/bash

git push && git push --tag

. $mt/checks/success $? 'Push error!'
