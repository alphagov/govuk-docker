content-publisher: $(GOVUK_ROOT_DIR)/content-publisher asset-manager publishing-api
	$(COMPOSE_RUN) content-publisher-default bundle
	$(COMPOSE_RUN) content-publisher-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(COMPOSE_RUN) content-publisher-default yarn
