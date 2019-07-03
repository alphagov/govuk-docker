content-store: $(GOVUK_ROOT_DIR)/content-store router-api govuk-content-schemas
	$(COMPOSE_RUN) content-store-lite bundle
	$(COMPOSE_RUN) content-store-lite bin/rake db:create
	$(COMPOSE_RUN) content-store-lite bin/rails runner 'User.first || User.create'
	$(COMPOSE_RUN) content-store-app-draft bin/rake db:create
	$(COMPOSE_RUN) content-store-app-draft bin/rails runner 'User.first || User.create'
