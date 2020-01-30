search-api: bundle-search-api publishing-api
	$(GOVUK_DOCKER) run $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices
	$(GOVUK_DOCKER) run $@-lite bundle exec rake message_queue:create_queues
	$(GOVUK_DOCKER) run $@-setup rake publishing_api:publish_eu_exit_business_finder
	$(GOVUK_DOCKER) run $@-setup rake publishing_api:publish_supergroup_finders
