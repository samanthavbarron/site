#!/bin/bash

set -e

cd $(dirname "$0")

git pull --no-edit

git ls-files --others --modified --exclude-standard | grep -v '^draft_' | xargs git add

git commit -m "auto-update"

git push

exit 0
