content-store_setup:
	govuk-docker run content-store-default bundle
	govuk-docker run content-store-default rake db:create
	govuk-docker run content-store-default rails runner 'User.first || User.create'
