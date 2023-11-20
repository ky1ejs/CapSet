#!/bin/sh

#  ci_post_clone.sh
#  CapSet
#
#  Created by Kyle Satti on 7/31/23.
#  

brew install swiftlint

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "on branch: $BRANCH"

if [[ "$BRANCH" == "main" || "$BRANCH" == "release" ]]; then
  brew install getsentry/tools/sentry-cli
fi
