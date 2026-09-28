govuk-chat: bundle-govuk-chat
	$(GOVUK_DOCKER_RUN) $@-lite bin/rails db:setup
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rails db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite yarn
	$(GOVUK_DOCKER_RUN) $@-lite bundle exec rake message_queue:create_published_documents_queue
	$(GOVUK_DOCKER_RUN) $@-lite bundle exec rake search:create_chunked_content_index
