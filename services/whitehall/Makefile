whitehall: $(GOVUK_ROOT_DIR)/whitehall asset-manager publishing-api static
	$(COMPOSE_RUN) whitehall-default bundle
	$(COMPOSE_RUN) whitehall-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(COMPOSE_RUN) whitehall-default rake shared_mustache:compile
	$(COMPOSE_RUN) whitehall-e2e rake taxonomy:populate_end_to_end_test_data
