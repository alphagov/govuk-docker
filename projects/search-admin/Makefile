search-admin: bundle-search-admin publishing-api
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER_RUN) $@-lite yarn
