#!/usr/bin/env bash

set -eu

if [[ "$#" == "0" ]]; then
  echo "usage: $0 \$app"
  exit 1
fi

app="${1//_/-}"

replication_dir="${GOVUK_DOCKER_REPLICATION_DIR:-${GOVUK_DOCKER_DIR:-${GOVUK_ROOT_DIR:-$HOME/govuk}/govuk-docker}/replication}"

bucket="govuk-integration-database-backups"
archive_dir="${replication_dir}/postgresql"

case "$app" in
  "support-api")
    archive_file="support_contacts_production.dump.gz"
    ;;
  *)
    archive_file="${app//-/_}_production.dump.gz"
    ;;
esac

archive_path="${archive_dir}/${archive_file}"

echo "Replicating postgres for $app"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$archive_dir"
  aws --profile govuk-integration s3 cp "s3://${bucket}/postgres/$(date '+%Y-%m-%d')/${archive_file}" "${archive_path}"
fi

echo "stopping running govuk-docker containers..."
govuk-docker down

govuk-docker up -d postgres
trap 'govuk-docker compose stop postgres' EXIT

echo "waiting for postgres..."
until govuk-docker run postgres /usr/bin/psql -h postgres -U postgres -c 'SELECT 1' &>/dev/null; do
  sleep 1
done

database="$app"
govuk-docker run postgres /usr/bin/psql -h postgres -U postgres -c "DROP DATABASE IF EXISTS \"${database}\""
govuk-docker run postgres /usr/bin/createdb -h postgres -U postgres "$database"
pv "$archive_path"  | gunzip | grep -v 'ALTER \(.*\) OWNER TO \(.*\);' | govuk-docker run postgres /usr/bin/psql -h postgres -U postgres -qAt -d "$database"
