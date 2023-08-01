#!/bin/sh

#  ci_post_xcode_build.sh
#  SetCap
#
#  Created by Kyle Satti on 7/31/23.
#  

export SENTRY_ORG=kylejs
export SENTRY_PROJECT=setcap

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" != "main" ]]; then
  echo "Skipping - dSYM upload to Sentry is only done on main"
  exit 0
fi

if which sentry-cli >/dev/null; then
    ERROR=$(sentry-cli upload-dif --include-sources "$CI_ARCHIVE_PATH/dSYMs" 2>&1 >/dev/null)
    if [ ! $? -eq 0 ]; then
        echo "warning: sentry-cli - $ERROR"
    fi
  else
    echo "warning: sentry-cli not installed, download from https://github.com/getsentry/sentry-cli/releases"
fi
