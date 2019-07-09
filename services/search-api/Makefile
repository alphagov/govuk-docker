search-api: bundle-search-api publishing-api
	$(GOVUK_DOCKER) compose run $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices
	$(GOVUK_DOCKER) compose run $@-lite bundle exec rake message_queue:create_queues

