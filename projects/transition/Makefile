transition: bundle-transition
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:prepare
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:prepare
