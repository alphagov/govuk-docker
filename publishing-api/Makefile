publishing-api: ../publishing-api content-store
	govuk-docker run publishing-api-default bundle
	govuk-docker run publishing-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	govuk-docker run publishing-api-default rails runner 'User.first || User.create'
	govuk-docker run publishing-api-default rake setup_exchange
