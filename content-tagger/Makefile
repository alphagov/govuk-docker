content-tagger_setup:
	govuk-docker run content-tagger-default bundle
	govuk-docker run content-tagger-default sh -c 'rake db:migrate 2>/dev/null || rake db:setup'
