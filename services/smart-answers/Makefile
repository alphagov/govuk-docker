smart-answers: $(GOVUK_ROOT_DIR)/smart-answers asset-manager publishing-api static
	$(GOVUK_DOCKER) compose build $@-lite
	$(GOVUK_DOCKER) compose run $@-lite rbenv install -s
	$(GOVUK_DOCKER) compose run $@-lite gem install --conservative bundler -v "~>1.0"
	$(GOVUK_DOCKER) compose run $@-lite bundle
