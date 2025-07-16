search-api-v2: prerequisites-search-api-v2 bundle-search-api-v2
	$(GOVUK_DOCKER) run --rm $@-lite bundle exec rake document_sync_worker:create_queue

BOLD_RED=\033[1;31m
REG_RED=\033[0;31m
RESET=\033[0m

define SEARCH_API_V2_WARN_GCLOUD
\033[1;31mWarning: gcloud not found on PATH.\n\
\033[0;31msearch-api-v2 requires credentials from the gcloud CLI to access Google Cloud Platform. \
These are mounted into the container. See the README for details.\033[0m
endef

prerequisites-search-api-v2:
	@command -v gcloud >/dev/null 2>&1 || { echo "$(SEARCH_API_V2_WARN_GCLOUD)"; }
