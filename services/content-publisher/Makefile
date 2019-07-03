content-publisher: $(GOVUK_ROOT_DIR)/content-publisher asset-manager publishing-api
	$(COMPOSE_RUN) content-publisher-lite bundle
	$(COMPOSE_RUN) content-publisher-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(COMPOSE_RUN) content-publisher-lite yarn
