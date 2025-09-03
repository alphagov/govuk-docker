authenticating-proxy: bundle-authenticating-proxy government-frontend
	$(GOVUK_DOCKER) run --rm $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run --rm $@-lite bin/rails runner 'User.first || User.create'
	$(GOVUK_DOCKER) run --rm $@-lite env RAILS_ENV=test bin/rails runner 'User.first || User.create'
