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

govuk_root_dir=${GOVUK_ROOT_DIR:-$HOME/govuk}
app=$1

echo "Fetching recent updates for ${bold}${app}${end_bold}" && git -C "${govuk_root_dir}/${app}" fetch --quiet

current_branch=$(git -C  "${govuk_root_dir}/${app}" branch --show-current)
if [ "$current_branch" != "main" ]; then
  echo "You are not currently on the main branch for ${bold}${app}${end_bold} (your branch: ${ul}${current_branch}${end_ul})"
  echo "Choose an option"
  select response in "Checkout main" "Ignore" "Quit"; do
    case $response in
      "Checkout main" ) git -C "${govuk_root_dir}/${app}" checkout main; break;;
      Ignore ) break;;
      Quit ) exit 1;;
    esac
  done
fi

current_branch=$(git -C "${govuk_root_dir}/${app}" branch --show-current)
head_commit=$(git -C "${govuk_root_dir}/${app}" rev-parse HEAD)

if ! git -C "${govuk_root_dir}/${app}" status -sb | grep 'origin/' -q; then
  echo "No upstream branch, skipping up to date with upstream check"
  exit 0
fi

origin_head_commit=$(git -C "${govuk_root_dir}/${app}" rev-parse "@{u}")

update_branch=${GOVUK_DOCKER_UPDATE_BRANCH:-ask}

if [ "$head_commit" != "$origin_head_commit" ]; then
  echo "Current branch (${ul}${current_branch}${end_ul}) for ${bold}${app}${end_bold} is not up to date with the origin (or does not match it)"
  if [ "$update_branch" == "always" ]; then
    echo "GOVUK_DOCKER_UPDATE_BRANCH set to always, so updating branch from origin"
    git -C "${govuk_root_dir}/${app}" pull
  else
    select response in "Update" "Ignore" "Quit"; do
      case $response in
        Update ) git -C "${govuk_root_dir}/${app}" pull; break;;
        Ignore ) break;;
        Quit ) exit 1;;
      esac
    done
  fi
fi
