#!/usr/local/bin/bash

git push && git push --tag

. checks/success $? 'Push error!'
