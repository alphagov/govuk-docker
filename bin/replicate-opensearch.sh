#!/usr/bin/env bash

set -eu

replication_dir="${GOVUK_DOCKER_REPLICATION_DIR:-${GOVUK_DOCKER_DIR:-${GOVUK_ROOT_DIR:-$HOME/govuk}/govuk-docker}/replication}"

bucket="govuk-integration-search-domain-opensearch-snapshots"
archive_path="${replication_dir}/opensearch-3"

echo "Replicating opensearch"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$replication_dir"
  aws s3 sync "s3://${bucket}/" "${archive_path}/"
fi

if [[ -n "${SKIP_IMPORT:-}" ]]; then
  echo "Skipping import as \$SKIP_IMPORT is set"
  exit 0
fi

# temporary config file because ES needs to be configured in advance
# for filesystem-based snapshots
mkdir -p -v './tmp'
cfg_path=$(mktemp './tmp/govuk-docker-data-sync.XXXXX')
echo "
  cluster.name: 'docker-cluster'
  network.host: 0.0.0.0
  path.repo: ['/replication']
  path.data: /usr/share/opensearch/data
" > "$cfg_path"

echo "stopping running govuk-docker containers..."
govuk-docker down

container=$(govuk-docker run -d --rm -v "$archive_path:/replication" -v "$cfg_path:/usr/share/opensearch/config/opensearch.yml" -p 9200:9200 opensearch-3 | tail -n1)
# we want $container and $cfg_path to be expanded now
# shellcheck disable=SC2064
trap "docker stop '$container'; rm '$cfg_path'" EXIT

echo "waiting for opensearch..."
until curl 127.0.0.1:9200 &>/dev/null; do
  sleep 1
done

echo "removing indices..."
curl -XDELETE "http://127.0.0.1:9200/_all"

echo "registering snapshot..."
curl "http://127.0.0.1:9200/_snapshot/snapshots" -X PUT -H 'Content-Type: application/json' -d '{
  "type": "fs",
  "settings": {
    "compress": true,
    "readonly": true,
    "location": "/replication"
  }
}'

# wait for opensearch to digest the snapshot metadata
sleep 5

snapshot_name=$(curl "http://127.0.0.1:9200/_snapshot/snapshots/_all" | jq -r ".snapshots | map(.snapshot) | sort | last")

indices=$(curl "http://127.0.0.1:9200/_snapshot/snapshots/$snapshot_name" | jq -r '
.snapshots[].indices
| [
    (map(select(startswith("page-traffic-"))) | sort | last),
    (map(select(startswith("metasearch-"))) | sort | last),
    (map(select(startswith("govuk-"))) | sort | last)
  ] | join(",")
')

echo "restoring indices..."
curl -XPOST "http://127.0.0.1:9200/_snapshot/snapshots/${snapshot_name}/_restore" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "indices": "${indices}"
}
EOF

while true; do
  sleep 5

  result=$(curl -s "http://127.0.0.1:9200/_cat/recovery?h=i,s,b,br,bp&active_only=true" | tr '\n' ' ')
  echo "$result"
  if [ -z "$result" ]; then
    echo
    echo "Restore complete."
    break
  fi
done
