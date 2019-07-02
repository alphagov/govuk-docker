content-tagger: ../content-tagger publishing-api
	bin/govuk-docker run content-tagger-default bundle
	bin/govuk-docker run content-tagger-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
