asset-manager: $(GOVUK_ROOT_DIR)/asset-manager
	$(COMPOSE_RUN) asset-manager-default bundle
	$(COMPOSE_RUN) asset-manager-default sh -c 'bin/rake db:migrate 2>/dev/null || bin/rake db:setup'
	$(COMPOSE_RUN) asset-manager-default bin/rails runner 'User.first || User.create'
