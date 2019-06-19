GOVUK_DOCKER_RUN=govuk-docker run whitehall-default

default:
	${GOVUK_DOCKER_RUN} bundle
	${GOVUK_DOCKER_RUN} sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
	${GOVUK_DOCKER_RUN} rake shared_mustache:compile
	govuk-docker run whitehall-e2e rake taxonomy:populate_end_to_end_test_data
