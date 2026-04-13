#!/usr/bin/env bash

##
# Checks main branch protection ruleset for deletion and non_fast_forward
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run this script
##

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ -z "$1" ]
then
  echo "usage: $0 <org> "
  exit 1
fi

GITHUB_ORG=$1

REPOSITORIES=$(gh repo list "$GITHUB_ORG" --no-archived --json name --limit 200 --visibility public | jq .[].name --raw-output)


echo "$REPOSITORIES" | while read -r REPOSITORY _; do
  echo "$REPOSITORY"
  MAIN_RULES=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    "/repos/$GITHUB_ORG/$REPOSITORY/rules/branches/main")

  MAIN_DELETION=$(echo "$MAIN_RULES"  | jq 'any( .type == "deletion" )')
  MAIN_NO_FORCE_PUSH=$(echo "$MAIN_RULES"  | jq 'any( .type == "non_fast_forward" )')
  echo " - main"
  if [[ "$MAIN_DELETION" == "true" ]]; then
    echo -e "  - ${GREEN}V${NC} delete"
  else
    echo -e "  - ${RED}X${NC} delete"
  fi
  if [[ "$MAIN_NO_FORCE_PUSH" == "true" ]]; then
    echo -e "  - ${GREEN}V${NC} no-force push"
  else
    echo -e "  - ${RED}X${NC} no-force push"
  fi
done
