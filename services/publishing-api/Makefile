publishing-api: $(GOVUK_ROOT_DIR)/publishing-api content-store govuk-content-schemas
	$(COMPOSE_RUN) publishing-api-default bundle
	$(COMPOSE_RUN) publishing-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(COMPOSE_RUN) publishing-api-default rails runner 'User.first || User.create'
	$(COMPOSE_RUN) publishing-api-default rake setup_exchange
