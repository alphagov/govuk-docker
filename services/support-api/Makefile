support-api: $(GOVUK_ROOT_DIR)/support-api
	$(COMPOSE_RUN) support-api-lite bundle
	$(COMPOSE_RUN) support-api-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
