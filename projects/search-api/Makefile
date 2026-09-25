wait-for-opensearch:
	@echo "Waiting for OpenSearch to be ready..."
	@until curl -s http://127.0.0.1:9200/_cluster/health > /dev/null 2>&1; do \
		echo "OpenSearch not available yet..."; \
		sleep 2; \
	done
	@echo "OpenSearch is up!"

search-api: bundle-search-api wait-for-opensearch
	@if curl -s "http://localhost:9200/_cat/indices" | grep -q "govuk-"; then \
      echo "Indices found, skipping index creation."; \
    else \
      echo "No indices found, creating all indices..."; \
      $(GOVUK_DOCKER_RUN) $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices; \
    fi
	$(GOVUK_DOCKER_RUN) $@-lite bundle exec rake message_queue:create_queues
