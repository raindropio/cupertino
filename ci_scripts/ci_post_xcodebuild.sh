#!/bin/sh

# Sentry upload dsym
echo "Uploading dSYM to Sentry"

sentry-cli --auth-token $SENTRY_AUTH_TOKEN \
    upload-dif --org 'oblako-corp' \
    --project 'cupertino' \
    $CI_ARCHIVE_PATH