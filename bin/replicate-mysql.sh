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
date=$(date '+%Y-%m-%d')

echo "Replicating mysql for $app"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$archive_dir"

  # Get a list of all of the MySQL database dump files, exclude them all,
  # include only the files that have the date and the app name in it.
  # https://docs.aws.amazon.com/cli/latest/reference/s3/#use-of-exclude-and-include-filters
  aws s3 cp "s3://${bucket}/mysql-backend/" "$archive_dir" --recursive --exclude "*" --include "$date*-${app//-/_}_production.gz"

  # List the archive directory, find a file with the date and the app name in
  # it, and rename that to a file that doesn't have a timestamp in its name.
  mv "$(find "$archive_dir" -name "$date*${app//-/_}*.gz")" "$archive_path"
fi

if [[ -n "${SKIP_IMPORT:-}" ]]; then
  echo "Skipping import as \$SKIP_IMPORT is set"
  exit 0
fi

echo "stopping running govuk-docker containers..."
govuk-docker down

mysql_container="$(govuk-docker config | ruby -ryaml -e "puts YAML::load(STDIN.read).dig('services', '${app}-lite', 'depends_on').keys.select { |k| k.start_with? 'mysql-' }")"
govuk-docker up -d "$mysql_container"
trap 'govuk-docker stop ${mysql_container}' EXIT

echo "waiting for mysql..."
until govuk-docker run "$mysql_container" mysql -h "$mysql_container" -u root --password=root -e 'SELECT 1' &>/dev/null; do
  sleep 1
done

database="${app//-/_}_development"

govuk-docker run "$mysql_container" mysql -h "$mysql_container" -u root --password=root -e "DROP DATABASE IF EXISTS \`${database}\`"
govuk-docker run "$mysql_container" mysql -h "$mysql_container" -u root --password=root -e "CREATE DATABASE \`${database}\`"
pv "$archive_path" | gunzip | govuk-docker run "$mysql_container" mysql -h "$mysql_container" -u root --password=root "$database"
