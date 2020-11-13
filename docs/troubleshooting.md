# Troubleshooting

## Troubleshoot: Usage

### Diagnose common issues when setting up GOV.UK Docker

Run the following command in `~/govuk/govuk-docker`. Since this script makes use of Ruby Gems, you will need to [install some additional dependencies](../CONTRIBUTING.md#testing) in order to do this.

```
bin/doctor
```

### Diagnose general issues with a project/app not working

```
# make sure GOV.UK Docker is up-to-date
git pull

# make sure the project is built OK
make <project>

# check if any dependencies have exited
docker ps -a

# tail logs for running services/dependencies
govuk-docker logs -f publishing-api-app

# try clearing all containers / volumes
govuk-docker rm -sv
```

### Diagnose issues with `dev.gov.uk` domains not resolving

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
# domain   : intro-to-docker.gov.uk
# nameserver[0] : 127.0.0.1
# port     : 53
# flags    : Request A records, Request AAAA records
# reach    : 0x00030002 (Reachable,Local Address,Directly Reachable Address)
```

You can also look at the command in `bin/setup` to see what's changing.

## Troubleshoot: Installation

### Diagnose common issues when setting up GOV.UK Docker

Run the following command in `~/govuk/govuk-docker`. Since this script makes use of Ruby Gems, you will need to [install some additional dependencies](../CONTRIBUTING.md#testing) in order to do this.

```
bin/doctor
```

### Resolve issues caused by an existing Docker installation

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
