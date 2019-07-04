search-api: $(GOVUK_ROOT_DIR)/$@ publishing-api
	$(GOVUK_DOCKER) compose run $@-lite bundle
	$(GOVUK_DOCKER) compose run $@-lite rbenv install -s && gem install --conservative bundler
	$(GOVUK_DOCKER) compose run $@-lite env SEARCH_INDEX=all bundle exec rake search:create_all_indices
	$(GOVUK_DOCKER) compose run $@-lite bundle exec rake message_queue:create_queues

