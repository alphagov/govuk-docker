signon_setup:
	govuk-docker run signon-default bundle
	govuk-docker run signon-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
