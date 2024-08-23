# How to Publish Content to a Finder in GOV.UK Docker

This guide explains how to use GOV.UK Docker to develop features for finders, and how to publish content to test your
finder with locally. The instructions below assume that you have "made" all of the relevant projects before starting.

This has been tested predominantly using Specialist Publisher, but other publishing apps should work just as well.

1. Start your publishing app of choice, e.g. `govuk-docker up specialist-publisher-app`
2. Start the finder-frontend app: `govuk-docker up finder-frontend-app`
3. Create a router backend for finder frontend: `curl http://router-api.dev.gov.uk/backends/finder-frontend -X PUT \
   -H 'Content-type: application/json' \
   -d '{"backend": {"backend_url": "http://finder-frontend.dev.gov.uk/"}}'`
4. Create a router backend for frontend (this is needed to serve the root taxon created in step 7): `curl http://router-api.dev.gov.uk/backends/frontend -X PUT \
      -H 'Content-type: application/json' \
      -d '{"backend": {"backend_url": "http://frontend.dev.gov.uk/"}}'`
5. Create a router backend for collections (this is needed to serve the test taxon created in step 8): `curl http://router-api.dev.gov.uk/backends/collections -X PUT \
      -H 'Content-type: application/json' \
      -d '{"backend": {"backend_url": "http://collections.dev.gov.uk/"}}'`
6. Publish Search API's routes by
   running `govuk-docker exec search-api-app bundle exec rake publishing_api:publish_special_routes`.
7. Publish the root taxon for GOV.UK: `govuk-docker run special-route-publisher-lite rake publish_homepage`
8. Publish a test taxon: `govuk-docker run whitehall-app-lite rails taxonomy:populate_end_to_end_test_data`, then `govuk-docker run whitehall-lite rails taxonomy:rebuild_cache`
9. Publish your specialist finder or general finder page.
    * For a specialist
      finder: `govuk-docker exec specialist-publisher-app bundle exec rails publishing_api:publish_finder\[finder_name\]`
    * For a general finder, e.g. the all content
      finder: `govuk-docker exec search-api-app env FINDER_CONFIG=all_content_finder.yml bundle exec rake publishing_api:publish_finder`
10. Create the search
    indices: `govuk-docker exec search-api-app env SEARCH_INDEX=all bundle exec rake search:create_all_indices`
11. Create the publishing api RabbitMQ exchange so that Search API can listen for new content to
    index: `govuk-docker exec publishing-api-app bundle exec rake setup_exchange`
12. Create the search API message
    queues: `govuk-docker exec search-api-worker bundle exec rake message_queue:create_queues`
13. Run `govuk-docker exec search-api-worker bundle exec rake message_queue:insert_data_into_govuk` to listen for
    messages. This is a long-running process, so you may want to start it in the background.
14. Publish a document. It should show up in the search results.

