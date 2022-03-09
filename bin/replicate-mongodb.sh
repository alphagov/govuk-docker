#!/usr/bin/env bash

set -eu

if [[ "$#" == "0" ]]; then
  echo "usage: $0 \$app"
  exit 1
fi

app="${1//_/-}"

replication_dir="${GOVUK_DOCKER_REPLICATION_DIR:-${GOVUK_DOCKER_DIR:-${GOVUK_ROOT_DIR:-$HOME/govuk}/govuk-docker}/replication}"

bucket="govuk-integration-database-backups"

mongo_version=3.6

case "$app" in
  "authenticating-proxy")
    hostname=router_backend
    database=authenticating_proxy_production
    ;;
  "router"|"draft-router")
    hostname=router_backend
    database="${app//-/_}"
    wait_for_rs=1
    ;;
  "asset-manager")
    hostname=mongo
    database=govuk_assets_production
    ;;
  "manuals-publisher"|"publisher"|"specialist-publisher")
    hostname=mongo
    database=govuk_content_production
    ;;
  *)
    hostname=mongo
    database="${app//-/_}_production"
    ;;
esac

archive_dir="${replication_dir}/mongodb"
archive_file="${hostname}.tar.gz"
archive_path="${archive_dir}/${archive_file}"

echo "Replicating mongodb for $app"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$archive_dir"
  remote_file_name=$(aws s3 ls "s3://${bucket}/mongodb/daily/${hostname}/" | tail -n1 | sed 's/^.* .* .* //')
  aws s3 cp "s3://${bucket}/mongodb/daily/${hostname}/${remote_file_name}" "$archive_path"
fi

if [[ -n "${SKIP_IMPORT:-}" ]]; then
  echo "Skipping import as \$SKIP_IMPORT is set"
  exit 0
fi

extract_path="${archive_path}-${app}"

if [[ -d "$extract_path" ]]; then
  rm -r "$extract_path"
fi
mkdir -p "$extract_path"

pv "$archive_path" | gunzip | tar -zx -f - -C "$extract_path" "var/lib/mongodb/backup/mongodump/${database}"

echo "stopping running govuk-docker containers..."
govuk-docker down

container=$(govuk-docker run -d --rm -v "${extract_path}:/replication" --name "mongo-${mongo_version}" mongo-${mongo_version} | tail -n1)
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

docker exec "$container" mongorestore --drop --db "$app" "/replication/var/lib/mongodb/backup/mongodump/${database}/"

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
