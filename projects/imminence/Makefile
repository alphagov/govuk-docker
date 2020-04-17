imminence: bundle-imminence
	$(GOVUK_DOCKER) run $@-lite bin/rake db:create
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:mongoid:create_indexes
