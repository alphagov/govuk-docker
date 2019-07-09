publisher: bundle-publisher publishing-api calendars link-checker-api
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
