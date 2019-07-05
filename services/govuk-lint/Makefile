govuk-lint: $(GOVUK_ROOT_DIR)/govuk-lint
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite rbenv install -s
	$(GOVUK_DOCKER) compose run $@-lite gem install --conservative bundler -v "~>2.0"
	$(GOVUK_DOCKER) compose run $@-lite bundle
