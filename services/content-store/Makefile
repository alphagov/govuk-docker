content-store: $(GOVUK_ROOT_DIR)/content-store router-api govuk-content-schemas
	$(COMPOSE_RUN) content-store-default bundle
	$(COMPOSE_RUN) content-store-default rake db:create
	$(COMPOSE_RUN) content-store-default rails runner 'User.first || User.create'
	$(COMPOSE_RUN) content-store-draft rake db:create
	$(COMPOSE_RUN) content-store-draft rails runner 'User.first || User.create'
