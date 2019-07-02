publisher: $(GOVUK_ROOT_DIR)/publisher
	$(COMPOSE_RUN) publisher-lite bundle
	$(COMPOSE_RUN) publisher-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
