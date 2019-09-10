email-alert-frontend: bundle-email-alert-frontend email-alert-api
	$(GOVUK_DOCKER) compose run $@-setup bin/rake publishing_api:publish_email_signup_page
	$(GOVUK_DOCKER) compose run $@-setup bin/rake publishing_api:publish_email_unsubscribe_prefix
	$(GOVUK_DOCKER) compose run $@-setup bin/rake publishing_api:publish_email_subscriptions_prefix
	$(GOVUK_DOCKER) compose run $@-setup bin/rake publishing_api:publish_email_authenticate_prefix
	$(GOVUK_DOCKER) compose run $@-setup bin/rake publishing_api:publish_email_manage_prefix
