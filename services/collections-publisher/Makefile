collections-publisher: $(GOVUK_ROOT_DIR)/$@ publishing-api content-store link-checker-api
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite bundle
	$(GOVUK_DOCKER) compose run $@-lite sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
