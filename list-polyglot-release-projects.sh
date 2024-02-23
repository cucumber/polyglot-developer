#!/usr/bin/env bash

##
# Lists all polyglot-release tagged Github projects in the Cucumber org.
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run this script
##

set -e

ORGANISATION=cucumber
gh repo list "$ORGANISATION" --topic polyglot-release
