search-api: $(GOVUK_ROOT_DIR)/search-api
	$(COMPOSE_RUN) search-api-lite bundle
	$(COMPOSE_RUN) search-api-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices

