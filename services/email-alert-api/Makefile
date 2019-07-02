email-alert-api: $(GOVUK_ROOT_DIR)/email-alert-api
	$(COMPOSE_RUN) email-alert-api-default bundle
	$(COMPOSE_RUN) email-alert-api-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
