#!/usr/bin/env bash

set -eu

bucket="govuk-integration-elasticsearch6-manual-snapshots"
archive_path="$HOME/govuk-data-sync/elasticsearch-6"

echo "Replicating elasticsearch"

if [[ -e "$archive_path" ]]; then
  echo "Skipping download - remove ${archive_path} to force"
else
  mkdir -p "$archive_path"
  aws --profile govuk-integration s3 sync "s3://${bucket}/" "${archive_path}/"
fi

# temporary config file because ES needs to be configured in advance
# for filesystem-based snapshots
cfg_path=$(mktemp '/tmp/govuk-docker-data-sync.XXXXX')
echo "
  cluster.name: 'docker-cluster'
  network.host: 0.0.0.0
  discovery.zen.minimum_master_nodes: 1
  path.repo: ['/replication']
" > "$cfg_path"

container=$(govuk-docker compose run -d --rm -v "$archive_path:/replication" -v "$cfg_path:/usr/share/elasticsearch/config/elasticsearch.yml" -p 9200:9200 elasticsearch6 | tail -n1)
# we want $container and $cfg_path to be expanded now
# shellcheck disable=SC2064
trap "docker stop '$container'; rm '$cfg_path'" EXIT

echo "waiting for elasticsearch..."
until curl 127.0.0.1:9200 &>/dev/null; do
  sleep 1
done

curl -XDELETE "http://127.0.0.1:9200/_all"
curl "http://127.0.0.1:9200/_snapshot/snapshots" -X PUT -H 'Content-Type: application/json' -d '{
  "type": "fs",
  "settings": {
    "compress": true,
    "readonly": true,
    "location": "/replication"
  }
}'

# wait for elasticsearch to digest the snapshot metadata
sleep 5

snapshot_name=$(curl "http://127.0.0.1:9200/_snapshot/snapshots/_all" | ruby -e 'require "json"; STDOUT << (JSON.parse(STDIN.read)["snapshots"].map { |a| a["snapshot"] }.sort.last)')
curl -XPOST "http://127.0.0.1:9200/_snapshot/snapshots/${snapshot_name}/_restore?wait_for_completion=true"
