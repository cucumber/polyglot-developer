#!/usr/bin/env bash

##
# Lists all LICENSE files in the projects supported by Tidelift
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run clone-all-projects.sh
# * Run this script
##

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

ORGANISATION=cucumber
TOPIC=tidelift
#use polyglot-release for a larger selection
#TOPIC=polyglot-release
REPOSITORIES=$(gh repo list "$ORGANISATION" --topic "$TOPIC" --no-archived --limit 999)

EXPECTED=$(grep -v "Copyright (c)" < cucumber/polyglot-developer/LICENSE)

echo "$REPOSITORIES" | while read -r REPOSITORY _; do
  LICENSE="$REPOSITORY/LICENSE"

  if [ ! -f "$LICENSE" ]; then
      echo -e "${RED}X${NC} $LICENSE - not found"
      continue
  fi

  ACTUAL=$(grep -v "Copyright (c)" < "$LICENSE")
  if diff <(echo "$EXPECTED") <(echo "$ACTUAL") &>/dev/null ; then
    echo -e "${GREEN}V${NC} $LICENSE"
  else
    echo -e "${RED}X${NC} $LICENSE - differs"
    diff <(echo "$EXPECTED") <(echo "$ACTUAL") || true
    echo
    echo
  fi
done