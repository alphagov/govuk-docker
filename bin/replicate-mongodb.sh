#!/usr/bin/env bash

set -eu

if [[ "$#" == "0" ]]; then
  echo "usage: $0 \$app"
  exit 1
fi

app="${1//_/-}"

replication_dir="${GOVUK_DOCKER_REPLICATION_DIR:-${GOVUK_DOCKER_DIR:-${GOVUK_ROOT_DIR:-$HOME/govuk}/govuk-docker}/replication}"

mongo_version=3.6

case "$app" in
  "router"|"draft-router")
    instance=router-mongo
    database="${app//-/_}"
    wait_for_rs=1
    ;;
  "asset-manager")
    instance=shared-documentdb
    database=govuk_assets_production
    ;;
  "publisher")
    instance=shared-documentdb
    database=govuk_content_production
    ;;
  *)
    instance=shared-documentdb
    database="${app//-/_}_production"
    ;;
esac

folder="govuk-integration-database-backups/$instance"

archive_dir="${replication_dir}/mongodb"
archive_file="${database}.gz"
archive_path="${archive_dir}/${archive_file}"

echo "Replicating mongodb for $app from $folder"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force a new download on the next run"
else
  mkdir -p "$archive_dir"
  remote_file_name=$(aws s3 ls "s3://${folder}/" | grep "[[:digit:]]Z-$database.gz" | tail -n1 | sed 's/^.* .* .* //')
  aws s3 cp "s3://${folder}/${remote_file_name}" "$archive_path"
fi

if [[ -n "${SKIP_IMPORT:-}" ]]; then
  echo "Skipping import as \$SKIP_IMPORT is set"
  exit 0
fi

extract_dir="${archive_dir}/${app}"
extract_file="${database}"

if [[ -d "$extract_dir" ]]; then
  rm -r "$extract_dir"
fi
mkdir -p "$extract_dir"

echo "Extracting to $extract_dir/$extract_file"

gunzip --stdout "$archive_path" > "$extract_dir/$extract_file"

echo "stopping running govuk-docker containers..."
govuk-docker down

container=$(govuk-docker run --detach --rm --volume "${extract_dir}:/replication" --name "mongo-${mongo_version}" mongo-${mongo_version} | tail -n1)

# we want $container to be expanded now
# shellcheck disable=SC2064
trap "docker stop '$container'" EXIT

echo "waiting for mongo..."

if [[ -n "${wait_for_rs:-}" ]]; then
  echo "Sleeping for 60s to allow replica set initialisation..."
  sleep 60
fi

until docker exec "$container" mongo --eval 1 &>/dev/null; do
  sleep 1
done

docker exec "$container" mongorestore --drop --nsFrom="${database}".* --nsTo="${app}".* --archive="/replication/${extract_file}"

case "$app" in
  "router")
    echo "Munging router backend hostnames"
    docker exec "$container" \
      mongo --quiet --eval 'db = db.getSiblingDB("router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.govuk-internal.digital", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
    ;;
  "draft-router")
    echo "Munging draft-router backend hostnames"
    docker exec "$container" \
      mongo --quiet --eval 'db = db.getSiblingDB("draft-router"); db.backends.find().forEach( function(b) { b.backend_url = b.backend_url.replace(".integration.govuk-internal.digital", ".dev.gov.uk").replace("https","http"); db.backends.save(b); } );'
    ;;
esac

