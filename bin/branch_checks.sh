#!/usr/bin/env bash

set -eu

if [[ "$#" == "0" ]]; then
  echo "usage: $0 \$app"
  exit 1
fi

bold=$(tput bold)
end_bold=$(tput sgr0)
ul=$(tput smul)
end_ul=$(tput sgr0)

govuk_root_dir="$HOME/govuk"
app=$1

root_branch=$(git -C "${govuk_root_dir}/${app}" branch -a | grep "remotes/origin/HEAD" | sed 's/ *remotes\/origin\/HEAD -> origin\///')

echo "Fetching recent updates for ${bold}${app}${end_bold}" && git -C "${govuk_root_dir}/${app}" fetch --quiet

current_branch=$(git -C  "${govuk_root_dir}/${app}" branch --show-current)
if [ "$current_branch" != "$root_branch" ]; then
  echo "You are not currently on the root branch (${ul}${root_branch}${end_ul}) for ${bold}${app}${end_bold} (your branch: ${ul}${current_branch}${end_ul})"
  echo "Choose an option"
  select response in "Checkout $root_branch" "Ignore" "Quit"; do
    case $response in
      "Checkout $root_branch" ) git -C "${govuk_root_dir}/${app}" checkout "${root_branch}"; break;;
      Ignore ) break;;
      Quit ) exit 1;;
    esac
  done
fi

current_branch=$(git -C "${govuk_root_dir}/${app}" branch --show-current)
head_commit=$(git -C "${govuk_root_dir}/${app}" rev-parse HEAD)
origin_head_commit=$(git -C "${govuk_root_dir}/${app}" rev-parse "@{u}")

if [ "$head_commit" != "$origin_head_commit" ]; then
  echo "Current branch for ${bold}${app}${end_bold} is not up to date with the origin (or does not match it)"
  select response in "Update" "Ignore" "Quit"; do
    case $response in
      Update ) git -C "${govuk_root_dir}/${app}" pull; break;;
      Ignore ) break;;
      Quit ) exit 1;;
    esac
  done
fi
