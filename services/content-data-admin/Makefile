content-data-admin: $(GOVUK_ROOT_DIR)/content-data-admin
	$(COMPOSE_RUN) content-data-admin-default bundle
	$(COMPOSE_RUN) content-data-admin-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
