# Local Frontend with port-forwarded supporting apps

Frontend has the app-live, app-integration and app-draft options, but they are increasingly complicated to maintain and have generally exluded postcode searches
and licences. To develop against integration or live (or even staging) versions
of these backend services we can now use kubernetes port forwarding.

From the app directory (~/govuk/frontend):

1) Log in to the appropriate AWS environment (we'll use integration as an example)

```eval $(gds aws govuk-$1-developer -e --art 8h)```

1) Use the appropriate context

```kubectl config use-context integration```

1) Run the port forward command

```../govuk-docker/bin/port-forward```

1) Run govuk-docker against the ports app

```../govuk-docker-run app-ports```

You should now be able to locally view postcode and licence pages as they appear in integration.

When you're finished, stop the port-forwarding with:

```pkill -f "kubectl port-forward"```
