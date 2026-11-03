# Local development with port-forwarded supporting apps

Apps such as Frontend have various stacks (app-live, app-integration,  app-draft), but they are increasingly complicated to maintain and have generally excluded things such as postcode searches
and licences. To develop against integration or live (or even staging) versions
of these backend services we can now use kubernetes port forwarding.
See this [PR for Frontend](https://github.com/alphagov/govuk-docker/pull/994) and [PR for Places Manager](https://github.com/alphagov/govuk-docker/pull/1026) on how to configure this as an additional service stack for an app.

From the app directory (e.g. ~/govuk/frontend):

1) Log in to the appropriate AWS environment (we'll use integration as an example). You'll need admin privileges, so fulladmin on integration or tempadmin
on other environments.

```eval $(gds aws govuk-integration-fulladmin -e --art 8h)```

1) Use the appropriate context

```kubectl config use-context integration```

1) Run the port forward command

```../govuk-docker/bin/port-forward```

1) Run govuk-docker against the ports app

```../govuk-docker-run app-ports```

You should now be able to locally view things such as postcode and licence pages as they appear in integration.

When you're finished, stop the port-forwarding with:

```pkill -f "kubectl port-forward"```
