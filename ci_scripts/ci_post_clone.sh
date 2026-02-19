#!/bin/sh

# Install sentry
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1
brew install getsentry/tools/sentry-cli

# Download Safari extension builds
cd $CI_PRIMARY_REPOSITORY_PATH
sh WebExtension/download-ios.command
sh WebExtension/download-macos.command