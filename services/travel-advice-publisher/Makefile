travel-advice-publisher: $(GOVUK_ROOT_DIR)/travel-advice-publisher asset-manager content-store publishing-api
	$(COMPOSE_RUN) travel-advice-publisher-default bundle
	$(COMPOSE_RUN) travel-advice-publisher-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
