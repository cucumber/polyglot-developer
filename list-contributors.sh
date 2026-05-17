#!/usr/bin/env bash

##
# Prints a list of the last 100 authors for all Cucumber repositories
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run clone-all-projects.sh
# * Run this script
##

set -e

function list_commits() {
    REPOSITORIES=$(find cucumber -mindepth 1 -maxdepth 1  -type d)

    for REPOSITORY in $REPOSITORIES; do
      pushd "$REPOSITORY" > /dev/null || exit 1
        git log --all --pretty="%ae;%an;$REPOSITORY;%ad" --date=short
      popd > /dev/null

    done
}

# List commits | sort by date (recent first) | for each email, keep only the most recent | sort by date (recent last) | keep only the last 100
list_commits | sort --field-separator=\; --key=4,4 --reverse | sort --unique --field-separator=\; --key=1,1 | sort --field-separator=\; --key=4,4 | tail -n 100
