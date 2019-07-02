asset-manager_setup: ../asset-manager
	govuk-docker run asset-manager-default bundle
	govuk-docker run asset-manager-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	govuk-docker run asset-manager-default rails runner 'User.first || User.create'
