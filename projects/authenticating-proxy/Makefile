authenticating-proxy: bundle-authenticating-proxy frontend
	$(GOVUK_DOCKER_RUN) $@-lite bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER_RUN) $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER_RUN) $@-lite env RAILS_ENV=test bin/rails runner 'User.first || User.create'
