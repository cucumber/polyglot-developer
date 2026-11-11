#!/usr/bin/env bash

##
# Prints a list of unreleased changes for each repository
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run clone-all-projects.sh
# * Run this script
##

REPOSITORIES=$(find cucumber -mindepth 1 -maxdepth 1  -type d)

for REPOSITORY in $REPOSITORIES; do
  pushd "$REPOSITORY" > /dev/null || exit 1
    if [ -f CHANGELOG.md ]; then
      unreleased=$(changelog show unreleased)
      if [ -n "$unreleased" ]; then
        echo "$REPOSITORY"
        echo "==========="
        echo "$unreleased"
        echo
      fi
    fi
  popd > /dev/null || exit 1
done

