# Troubleshooting

## `bin/setup` fails to succeed

If `bin/setup` fails on installing `dnsmasq`, make sure you're not overriding the `USER` env variable anywhere.

If you are (for setting the right SSH username), you'll want to remove that and set it in `~/.config/config.yaml` instead.

```yaml
# This is for govuk-connect: https://github.com/alphagov/govuk-connect/blob/1e14c58ce8e5d831aad3e2f8353d0e5204f83388/lib/govuk_connect/cli.rb#L230
# Can't set `export USER="yourname"` as this causes some unix things to fail (e.g. `brew install dnsmasq`)
# See https://github.com/alphagov/govuk-connect/issues/72
ssh_username: "yourname"
```

## Diagnose common issues when setting up GOV.UK Docker

Run the following command in `~/govuk/govuk-docker`.

```
bin/doctor
```

Since this script makes use of Ruby Gems, you will need to install some additional dependencies in order to do this.


First make sure you have the following dependencies:

- [rbenv](https://github.com/rbenv/rbenv#installation)

Next install Ruby / dependencies and run all the tests:

```sh
rbenv install

bundle install
```

## Diagnose database issues with a project/app not making

If you run `make` on an app inside govuk-docker and face any of the following database issues:

- `ActiveRecord::Migration` is not supported
- duplicate key error

...then it is likely that there is a conflict between the app and one of your existing volumes. This is because database contents are stored in a volume that the container uses, so when the container is recreated, it picks up the same data again.

The easiest resolution is to drop the database, e.g. `govuk-docker run content-store-lite bundle exec rails db:mongoid:drop`, and then try to `make` again.

A blunter solution would be to drop the volume altogether, by running `docker volume rm VOLUME_NAME`, where `VOLUME_NAME` can be derived from `docker volume ls`.

## Diagnose general issues with a project/app not working

* Make sure you run all commands via GOV.UK Docker.

```
govuk-docker-run bundle install
govuk-docker-run rake db:migrate
```

* Try repeating the action. If you got a `GdsApi::HTTPUnavailable` or `GdsApi::TimedOutException` the first time around, it could mean that Publishing API wasn't ready in time, as unfortunately there's no way for govuk-docker to know when each dependency is ready.

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

## Cannot `rails db:prepare` or start console due to "Plugin caching_sha2_password could not be loaded"

In MySQL 8.0 `caching_sha2_password` was made the default over the previous `mysql_native_password`.

This can lead to the following error when ActiveRecord is attempting to connect to the database, for example when running `rails db:prepare` or trying to bring up a rails console.

```
ActiveRecord::ConnectionNotEstablished: Plugin caching_sha2_password could not be loaded: /usr/lib/x86_64-linux-gnu/mariadb19/plugin/caching_sha2_password.so: cannot open shared object file: No such file or directory
```

A workaround is to get MySQL to fall back to using `mysql_native_password` as follows:

- Check that you can see `govuk-docker_mysql-8_1` when running `govuk-docker ps`, if not you will need to start a service that uses mysql (for example Whitehall).
- Bring up a mysql console inside the container: `docker exec -it govuk-docker_mysql-8_1 mysql --user=root --password=root`
- Alter the way the root user identifies itself. `ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'root';`

## Browser based tests fail with `NoSuchSessionError: invalid session id`

For example: Jasmine unit tests or feature specs that use Capybara

Docker allocates 64mb shared memory to containers by default, but recent versions of Chrome require more than this. Otherwise you'll start to see error messages complaining about an "invalid session id". In a previous discussion on Slack, it was informally agreed that 512mb seems to be the 'right sized' amount to allocate – but this was anecdotal, so other values may work equally well for our needs.

If the `shm_size` is too small, you'll get error messages that look something like this in your terminal:

```
NoSuchSessionError: invalid session id
    at Object.throwDecodedError (/govuk/whitehall/node_modules/selenium-webdriver/lib/error.js:522:15)
    at parseHttpResponse (/govuk/whitehall/node_modules/selenium-webdriver/lib/http.js:548:13)
    at Executor.execute (/govuk/whitehall/node_modules/selenium-webdriver/lib/http.js:474:28)
    at processTicksAndRejections (internal/process/task_queues.js:97:5)
    at async thenableWebDriverProxy.execute (/govuk/whitehall/node_modules/selenium-webdriver/lib/webdriver.js:735:17)
    at async Object.runSpecs (/govuk/whitehall/node_modules/jasmine-browser-runner/index.js:116:9)
    at async Command.runSpecs (/govuk/whitehall/node_modules/jasmine-browser-runner/lib/command.js:187:5) {
  remoteStacktrace: '#0 0xaaaabaf6b1b0 <unknown>\n' +
    '#1 0xaaaabada13b0 <unknown>\n' +
    '#2 0xaaaabadc7fe4 <unknown>\n' +
    '#3 0xaaaabadc9864 <unknown>\n' +
    '#4 0xaaaabafa75f8 <unknown>\n' +
    '#5 0xaaaabafa9d98 <unknown>\n' +
    '#6 0xaaaabafa9acc <unknown>\n' +
    '#7 0xaaaabaf987e0 <unknown>\n' +
    '#8 0xaaaabafaa500 <unknown>\n' +
    '#9 0xaaaabaf8e080 <unknown>\n' +
    '#10 0xaaaabafc1790 <unknown>\n' +
    '#11 0xaaaabafc1950 <unknown>\n' +
    '#12 0xaaaabafdbbd4 <unknown>\n' +
    '#13 0xffffb0f28628 <unknown>\n' +
    '#14 0xffffb075501c <unknown>\n'
}
error Command failed with exit code 1.
```

To resolve it, check your project's `docker-compose.yml` file. The `*-lite` service will need a `shm_size` config to be added.

For example:

```yaml
services:
  whitehall-lite:
    <<: *whitehall
    shm_size: 512mb
    depends_on:
      - mysql-8
      - redis
    # ...
```

For further examples, see the PR [alphagov/govuk-docker#613](https://github.com/alphagov/govuk-docker/pull/613).
