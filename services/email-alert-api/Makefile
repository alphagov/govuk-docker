email-alert-api: ../email-alert-api
	bin/govuk-docker run email-alert-api-default bundle
	bin/govuk-docker run email-alert-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
