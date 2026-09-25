account-api: bundle-account-api content-store
	$(GOVUK_DOCKER_RUN) $@-lite bin/rails db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rails db:prepare
