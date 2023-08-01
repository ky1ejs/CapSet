#!/bin/sh

#  ci_post_clone.sh
#  SetCap
#
#  Created by Kyle Satti on 7/31/23.
#  

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "main" ]]; then
  brew install getsentry/tools/sentry-cli
fi
