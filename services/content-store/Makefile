content-store: $(GOVUK_ROOT_DIR)/content-store router-api govuk-content-schemas
	$(COMPOSE_RUN) content-store-default bundle
	$(COMPOSE_RUN) content-store-default bin/rake db:create
	$(COMPOSE_RUN) content-store-default bin/rails runner 'User.first || User.create'
	$(COMPOSE_RUN) content-store-draft bin/rake db:create
	$(COMPOSE_RUN) content-store-draft bin/rails runner 'User.first || User.create'
