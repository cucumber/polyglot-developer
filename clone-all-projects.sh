#!/usr/bin/env bash

##
# Clones all public unarchived Github projects from the Cucumber org.
#
# If the project already exists, it will try to pull the repository
# instead.
#
# Projects will be written to <current directory/cucumber/<repository>
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run this script
##

set -e

ORGANISATION=cucumber
REPOSITORIES=$(gh repo list "$ORGANISATION" --no-archived --limit 999)

echo "$REPOSITORIES" | while read -r REPOSITORY _; do
  if [ ! -d "$REPOSITORY" ]; then
    echo "Cloning $REPOSITORY"
    gh repo clone "$REPOSITORY" "$REPOSITORY" &
  else
    echo "Pulling $REPOSITORY"
    git -C "$REPOSITORY" pull --quiet &
  fi
done

wait
