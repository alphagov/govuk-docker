GOVUK_DOCKER_RUN=govuk-docker run content-store-default

default:
	${GOVUK_DOCKER_RUN} bundle
	${GOVUK_DOCKER_RUN} rake db:create
	${GOVUK_DOCKER_RUN} rails runner 'User.first || User.create'
