signon: ../signon
	bin/govuk-docker run signon-default bundle
	bin/govuk-docker run signon-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
