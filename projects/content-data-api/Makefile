content-data-api: bundle-content-data-api
	$(GOVUK_DOCKER) run $@-lite bundle exec rake db:prepare
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bundle exec rake db:prepare
