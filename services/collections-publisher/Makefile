collections-publisher: bundle-collections-publisher publishing-api content-store link-checker-api
	$(GOVUK_DOCKER) run $@-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	$(GOVUK_DOCKER) run $@-lite yarn
