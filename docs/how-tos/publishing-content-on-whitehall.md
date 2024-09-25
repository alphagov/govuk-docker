# Publishing Content from Whitehall for Developing Government Frontend

This guide explains how to use GOV.UK Docker to develop features for government frontend, and how to publish content to test your
work with locally. The instructions below assume that you have "made" all of the relevant projects before starting.

1. Start the Whitehall app: `govuk-docker up whitehall-app`
2. Start the government-frontend app: `govuk-docker up government-frontend-app`
3. Create a router backend for government frontend:
   ```bash
   curl http://router-api.dev.gov.uk/backends/government-frontend -X PUT \
   -H 'Content-type: application/json' \
   -d '{"backend": {"backend_url": "http://government-frontend.dev.gov.uk/"}}'
   ```
4. Create a router backend for frontend (this is needed to serve the root taxon created in step 7):
   ```bash
   curl http://router-api.dev.gov.uk/backends/frontend -X PUT \
   -H 'Content-type: application/json' \
   -d '{"backend": {"backend_url": "http://frontend.dev.gov.uk/"}}'
   ```
5. Create a router backend for collections (this is needed to serve the test taxon created in step 8):
   ```bash
   curl http://router-api.dev.gov.uk/backends/collections -X PUT \
   -H 'Content-type: application/json' \
   -d '{"backend": {"backend_url": "http://collections.dev.gov.uk/"}}'
   ```
7. Publish the homepage and root taxon for GOV.UK: `govuk-docker run publishing-api rake publish_homepage`
8. Publish a test taxon so that we can tag Whitehall content with it:

   ```bash
   govuk-docker run whitehall-app-lite rails taxonomy:populate_end_to_end_test_data
   govuk-docker run whitehall-lite rails taxonomy:rebuild_cache
   ```
9. Publish a document. You should be able to access it at `http://government-frontend.dev.gov.uk/{{your_base_path_here}}`
