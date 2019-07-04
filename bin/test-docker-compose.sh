set -eux

# Redirect STDERR to a file
bin/govuk-docker compose config --quiet 2> stderr.log

# And check if the file is empty
if [ -s stderr.log ]; then
  cat stderr.log
  exit 1
else
  echo "No errors found in docker compose config"
fi
