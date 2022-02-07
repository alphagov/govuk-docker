#!/usr/bin/env bash

function try_find_file {
  app="$1"
  db_hostname="${app}-mysql"

  set +e
  # Find the most recent database dump from that host
  out="$(aws s3 ls "s3://${bucket}/${db_hostname}/" | grep "\.gz$" | sed 's/.* //' | sort | tail -n1)"
  set -e

  if [[ -n "$out" ]]; then
    echo "${db_hostname}/${out}"
  fi
}

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

  s3_file=$(try_find_file "$app")
  if [[ -z "$s3_file" ]]; then
    echo "couldn't figure out backup filename in S3 - if you're sure the app uses MySQL, file an issue in alphagov/govuk-docker."
    exit 1
  fi
  aws s3 cp "s3://${bucket}/${s3_file}" "${archive_path}"
fi

if [[ -n "${SKIP_IMPORT:-}" ]]; then
  echo "Skipping import as \$SKIP_IMPORT is set"
  exit 0
fi

echo "stopping running govuk-docker containers..."
govuk-docker down

mysql_container="$(govuk-docker config | ruby -ryaml -e "puts YAML::load(STDIN.read).dig('services', '${app}-lite', 'depends_on').keys.select { |k| k.start_with? 'mysql-' }")"
govuk-docker up -d "$mysql_container"
trap 'govuk-docker down' EXIT

echo "waiting for mysql..."
until govuk-docker run --rm -T "$mysql_container" mysql -h "$mysql_container" -u root --password=root -e 'SELECT 1' &>/dev/null; do
  sleep 1
done

# Extract the local database name from the app's DATABASE_URL environment variable
database="$(govuk-docker config | ruby -ryaml -e "puts YAML::load(STDIN.read).dig('services', '${app}-app', 'environment', 'DATABASE_URL').split('/').last")"

govuk-docker run --rm -T "$mysql_container" mysql -h "$mysql_container" -u root --password=root -e "DROP DATABASE IF EXISTS \`${database}\`"
govuk-docker run --rm -T "$mysql_container" mysql -h "$mysql_container" -u root --password=root -e "CREATE DATABASE \`${database}\`"
pv "$archive_path" | gunzip | govuk-docker run --rm -T "$mysql_container" mysql -h "$mysql_container" -u root --password=root "$database"
