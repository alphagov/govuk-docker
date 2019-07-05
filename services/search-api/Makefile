search-api: $(GOVUK_ROOT_DIR)/$@ publishing-api
	govuk-docker compose run $@-lite bundle
	govuk-docker compose run $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices
	govuk-docker compose run $@-lite bundle exec rake message_queue:create_queues

