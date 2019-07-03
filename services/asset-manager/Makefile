asset-manager: $(GOVUK_ROOT_DIR)/asset-manager
	$(COMPOSE_RUN) asset-manager-default bundle
	$(COMPOSE_RUN) asset-manager-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(COMPOSE_RUN) asset-manager-default rails runner 'User.first || User.create'
