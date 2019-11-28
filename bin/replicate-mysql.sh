#!/usr/bin/env bash

set -eu

if [[ "$#" == "0" ]]; then
  echo "usage: $0 \$app"
  exit 1
fi

app="${1//_/-}"

replication_dir="${GOVUK_DOCKER_REPLICATION_DIR:-${GOVUK_DOCKER_DIR:-${GOVUK_ROOT_DIR:-$HOME/govuk}/govuk-docker}/replication}"

bucket="govuk-integration-database-backups"
archive_dir="${replication_dir}/mysql"
archive_file="${app//-/_}_production.dump.gz"
archive_path="${archive_dir}/${archive_file}"

echo "Replicating mysql for $app"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$archive_dir"
  aws s3 cp "s3://${bucket}/mysql/$(date '+%Y-%m-%d')/${archive_file}" "${archive_path}"
fi

if [[ -n "${SKIP_IMPORT:-}" ]]; then
  echo "Skipping import as \$SKIP_IMPORT is set"
  exit 0
fi

echo "stopping running govuk-docker containers..."
govuk-docker down

govuk-docker up -d mysql
trap 'govuk-docker stop mysql' EXIT

echo "waiting for mysql..."
until govuk-docker run mysql mysql -h mysql -u root --password=root -e 'SELECT 1' &>/dev/null; do
  sleep 1
done

database="${app//-/_}_development"

govuk-docker run mysql mysql -h mysql -u root --password=root -e "DROP DATABASE IF EXISTS \`${database}\`"
govuk-docker run mysql mysql -h mysql -u root --password=root -e "CREATE DATABASE \`${database}\`"
pv "$archive_path" | gunzip | govuk-docker run mysql mysql -h mysql -u root --password=root "$database"
