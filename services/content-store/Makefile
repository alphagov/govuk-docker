content-store: $(GOVUK_ROOT_DIR)/$@ router-api govuk-content-schemas
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite rbenv install -s && gem install --conservative bundler
	$(GOVUK_DOCKER) compose run $@-lite bundle
	$(GOVUK_DOCKER) compose run $@-lite bin/rake db:create
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) compose run $@-app-draft bin/rake db:create
	$(GOVUK_DOCKER) compose run $@-app-draft bin/rails runner 'User.first || User.create'
