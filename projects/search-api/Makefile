wait-for-elasticsearch:
	@echo "Waiting for Elasticsearch to be ready..."
	@until curl -s http://127.0.0.1:9200/_cluster/health > /dev/null 2>&1; do \
		echo "Elasticsearch not available yet..."; \
		sleep 2; \
	done
	@echo "Elasticsearch is up!"

search-api: bundle-search-api wait-for-elasticsearch
	@if curl -s "http://localhost:9200/_cat/indices" | grep -q "government-"; then \
      echo "Indices found, skipping index creation."; \
    else \
      echo "No indices found, creating all indices..."; \
      $(GOVUK_DOCKER) run $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices; \
    fi
	$(GOVUK_DOCKER) run $@-lite bundle exec rake message_queue:create_queues
