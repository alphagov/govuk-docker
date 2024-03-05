govuk-chat: bundle-govuk-chat
	$(GOVUK_DOCKER) run $@-lite bin/rails db:setup
	$(GOVUK_DOCKER) run $@-lite env RAILS_ENV=test bin/rails db:prepare
	$(GOVUK_DOCKER) run $@-lite yarn
