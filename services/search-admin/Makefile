search-admin: $(GOVUK_ROOT_DIR)/search-admin publishing-api search-api
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite rbenv install -s
	$(GOVUK_DOCKER) compose run $@-lite gem install --conservative bundler -v "~>1.0"
	$(GOVUK_DOCKER) compose run $@-lite bundle
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(GOVUK_DOCKER) compose run $@-lite bin/rails runner 'User.first || User.create'
