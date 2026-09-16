places-manager: bundle-places-manager local-links-manager locations-api
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:setup
