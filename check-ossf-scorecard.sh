#!/usr/bin/env bash

##
# Prints the OSSF scores for all Cucumber projects
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
  response=$(curl --silent --fail "https://api.scorecard.dev/projects/github.com/$REPOSITORY" || echo '{"score": "n/a"}')
  score=$(echo "$response" | jq .score --raw-output)
  echo "$REPOSITORY $score "
done
