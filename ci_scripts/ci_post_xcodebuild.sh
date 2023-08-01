#!/bin/sh

#  ci_post_xcode_build.sh
#  SetCap
#
#  Created by Kyle Satti on 7/31/23.
#  


if which sentry-cli >/dev/null; then
    ERROR=$(sentry-cli upload-dif --include-sources "$CI_ARCHIVE_PATH/dSYMs" 2>$1 >/dev/null)
    if [ ! $? -eq 0 ]; then
        echo "warning: sentry-cli - $ERROR"
    fi
  else
    echo "warning: sentry-cli not installed, download from https://github.com/getsentry/sentry-cli/releases"
fi
