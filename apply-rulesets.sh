#!/usr/bin/env bash

##
# Apply branch and tag protection rulesets. Does not check if this makes sense.
#
# For example: Aruba has a different set of rules.
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run this script
##

set -e

if [ -z "$1" ]
then
  echo "usage: $0 <org> "
  exit 1
fi

GITHUB_ORG=$1

REPOSITORIES=$(gh repo list "$GITHUB_ORG" --no-archived --json name --limit 200 --visibility public | jq .[].name --raw-output)


echo "$REPOSITORIES" | while read -r REPOSITORY _; do
  echo "$REPOSITORY"
  gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2026-03-10" "/repos/$GITHUB_ORG/$REPOSITORY/rulesets" --input rulesets/main.json || true
  gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2026-03-10" "/repos/$GITHUB_ORG/$REPOSITORY/rulesets" --input rulesets/release.json || true
  gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2026-03-10" "/repos/$GITHUB_ORG/$REPOSITORY/rulesets" --input rulesets/tags.json || true
done


