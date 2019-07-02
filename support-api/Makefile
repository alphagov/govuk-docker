support-api: ../support-api
	govuk-docker run support-api-default bundle
	govuk-docker run support-api-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
