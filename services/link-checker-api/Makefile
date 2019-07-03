link-checker-api: $(GOVUK_ROOT_DIR)/link-checker-api
	$(COMPOSE_RUN) link-checker-api-default bundle
	$(COMPOSE_RUN) link-checker-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
