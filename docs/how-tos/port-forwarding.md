# Local development with port-forwarded supporting apps

Apps such as Frontend have various stacks (app-live, app-integration,  app-draft), but they are increasingly complicated to maintain and have generally excluded things such as postcode searches
and licences. To develop against integration or live (or even staging) versions
of these backend services we can now use kubernetes port forwarding.
See this [PR for Frontend](https://github.com/alphagov/govuk-docker/pull/994) and [PR for Places Manager](https://github.com/alphagov/govuk-docker/pull/1026) on how to configure this as an additional service stack for an app.

From the app directory (e.g. ~/govuk/frontend):

1) Log in to the appropriate AWS environment (we'll use integration as an example)

```eval $(gds aws govuk-$1-developer -e --art 8h)```

1) Use the appropriate context

```kubectl config use-context integration```

1) Run the port forward command

```../govuk-docker/bin/port-forward```

1) Run govuk-docker against the ports app

```../govuk-docker-run app-ports```

You should now be able to locally view things such as postcode and licence pages as they appear in integration.

When you're finished, stop the port-forwarding with:

```pkill -f "kubectl port-forward"```

## Mixing locally-running apps with port-forwarded apps

Note that you can use this (and other options like app-live and app-integration for apps that have them) in concert
with individual overrides. For instance, if you wanted to run frontend locally pointing to an experimental branch
of local-links-manager, but backed by content-store, locations-api, and places manager from the production cluster,
you could add

```PLEK_SERVICE_LOCAL_LINKS_MANAGER_URI=http://local-links-manager.dev.gov.uk```

...to your `.env` file in Frontend, then run Frontend with port-forwarding as above, and in a separate console run
local-links-manager. The value in `.env` will override `PLEK_SERVICE_LOCAL_LINKS_MANAGER_URI` from the docker
container, and you'll be able to test the integration between the two apps in question without running up an
entire cluster of all the apps.
