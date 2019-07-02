publishing-api: ../publishing-api content-store
	bin/govuk-docker run publishing-api-default bundle
	bin/govuk-docker run publishing-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	bin/govuk-docker run publishing-api-default rails runner 'User.first || User.create'
	bin/govuk-docker run publishing-api-default rake setup_exchange
