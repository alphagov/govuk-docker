search-api: bundle-search-api
	$(GOVUK_DOCKER) run $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices
	$(GOVUK_DOCKER) run $@-lite bundle exec rake message_queue:create_queues
