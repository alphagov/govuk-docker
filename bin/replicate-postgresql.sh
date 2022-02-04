#!/usr/bin/env bash

function try_find_file {
  app="$1"

  # Work out the database hostname
  case "$app" in
    "bouncer"|"transition")
      # Bouncer and Transition share a database with a non-standard hostname (ending with "postgresql" not "postgres")
      db_hostname="transition-postgresql"
      ;;
    "content-data-api")
      # Content Data API has a non-standard hostname (ending with "postgresql" not "postgres")
      db_hostname="content-data-api-postgresql"
      ;;
    *)
      db_hostname="${app}-postgres"
      ;;
  esac

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

archive_dir="${replication_dir}/postgresql"
archive_file="${app//-/_}_production.dump.gz"
archive_path="${archive_dir}/${archive_file}"

echo "Replicating postgres for $app"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$archive_dir"
  s3_file=$(try_find_file "$app")
  if [[ -z "$s3_file" ]]; then
    echo "couldn't figure out backup filename in S3 - if you're sure the app uses PostgreSQL, file an issue in alphagov/govuk-docker."
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

postgres_container="$(govuk-docker config | ruby -ryaml -e "puts YAML::load(STDIN.read).dig('services', '${app}-lite', 'depends_on').keys.select { |k| k.start_with? 'postgres-' }")"
govuk-docker up -d "$postgres_container"
trap 'govuk-docker down' EXIT

echo "waiting for postgres..."
until govuk-docker run --rm -T "$postgres_container" /usr/bin/psql -h "$postgres_container" -U postgres -c 'SELECT 1' &>/dev/null; do
  sleep 1
done

# Extract the local database name from the app's DATABASE_URL environment variable
database="$(govuk-docker config | ruby -ryaml -e "puts YAML::load(STDIN.read).dig('services', '${app}-app', 'environment', 'DATABASE_URL').split('/').last")"

govuk-docker run --rm -T "$postgres_container" /usr/bin/psql -h "$postgres_container" -U postgres -c "DROP DATABASE IF EXISTS \"${database}\""
govuk-docker run --rm -T "$postgres_container" /usr/bin/createdb -h "$postgres_container" -U postgres "$database"
pv "$archive_path" | govuk-docker run --rm -T "$postgres_container" /usr/bin/pg_restore -h "$postgres_container" -U postgres -d "$database" --no-owner --no-privileges
