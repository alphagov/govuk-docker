support-api: ../support-api
	bin/govuk-docker run support-api-default bundle
	bin/govuk-docker run support-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
