whitehall_setup:
	govuk-docker run whitehall-default bundle
	govuk-docker run whitehall-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	govuk-docker run whitehall-default rake shared_mustache:compile
