#!/usr/bin/env bash

##
# Lists the last 100 issues and pull requests created by a github user, updated since a given date
#
# Usage:
#
# * Install the Github CLI https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# * Run gh auth login
# * Run this script
##

set -e

if [ -z "$3" ]
then
  echo "usage: $0 <org> <user> <yyyy-mm-dd>"
  exit 1
fi

GITHUB_ORG=$1
GITHUB_USER=$2
UPDATED_SINCE=$3

QUERY_TEMPLATE='
{
  search(query: "org:GITHUB_ORG author:GITHUB_USER  updated:>=UPDATED_SINCE sort:created-desc ", type: ISSUE, last: 100) {
    edges {
      node {
        ... on PullRequest {
          url
          title
          createdAt
          updatedAt
        }
        
        ... on Issue {
          url
          title
          createdAt
          updatedAt
        }
      }
    }
  }
}
'

QUERY=$(echo "$QUERY_TEMPLATE" |  sed "s/GITHUB_ORG/$GITHUB_ORG/" | sed "s/GITHUB_USER/$GITHUB_USER/" | sed "s/UPDATED_SINCE/$UPDATED_SINCE/") 
echo "createdAt,updatedAt,title,url"
gh api graphql -f query="$QUERY" | jq -r '.data.search.edges[].node | .createdAt[0:10] + "," + .updatedAt[0:10] + ",\"" + (.title | gsub("\"";"\"\"")) + "\"," + .url'
