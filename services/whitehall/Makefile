whitehall: $(GOVUK_ROOT_DIR)/whitehall asset-manager publishing-api static
	$(COMPOSE_RUN) whitehall-lite bundle
	$(COMPOSE_RUN) whitehall-lite sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(COMPOSE_RUN) whitehall-lite bin/rake shared_mustache:compile
	$(COMPOSE_RUN) whitehall-app-e2e bin/rake taxonomy:populate_end_to_end_test_data
