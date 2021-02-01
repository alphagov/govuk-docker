content-tagger: bundle-content-tagger publishing-api
	$(GOVUK_DOCKER) run $@-lite bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rake db:setup
	$(GOVUK_DOCKER) run $@-lite yarn
