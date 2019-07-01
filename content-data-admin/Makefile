content-data-admin_setup:
	govuk-docker run content-data-admin-default bundle
	govuk-docker run content-data-admin-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
