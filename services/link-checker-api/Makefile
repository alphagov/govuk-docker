link-checker-api: $(GOVUK_ROOT_DIR)/link-checker-api
	$(COMPOSE_RUN) link-checker-api-default bundle
	$(COMPOSE_RUN) link-checker-api-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
