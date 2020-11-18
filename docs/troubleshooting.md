# Troubleshooting

## Diagnose common issues when setting up GOV.UK Docker

Run the following command in `~/govuk/govuk-docker`. Since this script makes use of Ruby Gems, you will need to [install some additional dependencies](../CONTRIBUTING.md#testing) in order to do this.

```
bin/doctor
```

## Diagnose general issues with a project/app not working

* Make sure you run all commands via GOV.UK Docker.

```
govuk-docker-run bundle install
govuk-docker-run rake db:migrate
```

* Check if one of the dependencies is the problem.

> A common problem for dependencies is when you've previously `git pull`ed the repo, but haven't run `bundle install` or `rake db:migrate`. The logs for the dependency will show if this is the problem.

```
# check if any dependencies have exited
docker ps -a

# check logs for an exited dependency
govuk-docker logs -f publishing-api-app
```

* Try cleaning up and running your command again.

```
# stop all apps and their dependencies
govuk-docker down

# make sure GOV.UK Docker is up-to-date
git pull
```

## Diagnose issues with `dev.gov.uk` domains not resolving

* Check if `dev.gov.uk` works end-to-end

```
dig app.dev.gov.uk @127.0.0.1

# output should contain...
# app.dev.gov.uk.		0	IN	A	127.0.0.1
```

* Check your `/etc/resolver` config is working

```
scutil --dns

# output should contain...
# domain   : dev.gov.uk
# nameserver[0] : 127.0.0.1
# port     : 53
# flags    : Request A records, Request AAAA records
# reach    : 0x00030002 (Reachable,Local Address,Directly Reachable Address)
```

* Re-run the setup script and look for errors

```
bin/setup
```

## Resolve issues caused by an existing Docker installation

You may get one of the following errors when running `bin/setup`.

```
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/docker-compose
Target /usr/local/bin/docker-compose
...
```

```
Error: It seems there is already an App at '/Applications/Docker.app'.
```

This isn't a problem if you already have Docker/Compose installed, and the setup script will continue to run. If you like, you can remove your existing Docker/Compose and run `bin/setup` again.
