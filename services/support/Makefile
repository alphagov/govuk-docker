support: $(GOVUK_ROOT_DIR)/$@ support-api
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite rbenv install -s && gem install --conservative bundler
	$(GOVUK_DOCKER) compose run $@-lite bundle
