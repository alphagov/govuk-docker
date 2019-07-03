specialist-publisher: $(GOVUK_ROOT_DIR)/specialist-publisher asset-manager publishing-api
	$(COMPOSE_RUN) specialist-publisher-default bundle
	$(COMPOSE_RUN) specialist-publisher-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
