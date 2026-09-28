travel-advice-publisher: bundle-travel-advice-publisher asset-manager content-store publishing-api
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite yarn
