public-asset-checker: bundle-public-asset-checker
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:prepare
