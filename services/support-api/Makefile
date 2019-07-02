support-api: $(GOVUK_ROOT_DIR)/support-api
	$(COMPOSE_RUN) support-api-default bundle
	$(COMPOSE_RUN) support-api-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
