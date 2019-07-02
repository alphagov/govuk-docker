content-data-admin_setup: ../content-data-admin
	govuk-docker run content-data-admin-default bundle
	govuk-docker run content-data-admin-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
