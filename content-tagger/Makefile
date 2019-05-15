GOVUK_DOCKER_RUN=govuk-docker run content-tagger-default

default:
	${GOVUK_DOCKER_RUN} bundle
	${GOVUK_DOCKER_RUN} sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
