# GOV.UK Docker

GOV.UK development environment using Docker.

![diagram](docs/diagram.png)

The GOV.UK website uses a microservice architecture. Developing in this ecosystem is a challenge, due to the range of environments to maintain, both for the app being developed and its dependencies.

The aim of govuk-docker is to make it easy to develop any GOV.UK app. It achieves this by providing a variety of environments or _stacks_ for each app, in which you can run commands, and the app itself.

[RFC 106: Use Docker for local development](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-106-docker-for-local-development.md) describes the background for choosing Docker. See the [list of projects which work with govuk-docker](docs/compatibility.md).

## Installation

**First make sure you have the following dependencies.**

- [brew](https://brew.sh/)
- [git](https://git-scm.com)
- A `govuk` directory in your home directory

**Next, add the following line to your bash/zsh config.**


```
# in ~/.bashrc or ~/.zshrc
export PATH=$PATH:~/govuk/govuk-docker/exe
```

Run `echo $SHELL` if you're not sure which shell you use. After saving, you will need to run `source ~/.bashrc` or `source ~/.zshrc` to apply this change to your current terminal session.

**Now in `~/govuk` , run the following setup commands.**

```
git clone git@github.com:alphagov/govuk-docker.git
cd govuk-docker
bundle install
bin/setup
```

👉 [Check the troubleshooting guide if you have a problem.](docs/troubleshooting.md#installation)

**Then make sure you give Docker enough resources.**

Running GOV.UK applications can be resource intensive. To give Docker more resources on Mac, click the Docker whale icon in the macOS menu bar, select 'Preferences'. We suggest the following minimum resources:

* 6 CPUs
* 12 GB RAM
* 64GB+ Disk

**Check out the how-to guide to customise your setup.**

- [Replicate data locally](docs/how-tos.md#how-to-replicate-data-locally)

- [Setup shortcuts to reduce typing](docs/how-tos.md#how-to-reduce-typing-with-shortcuts)

## Usage

Do this the first time you work on a project:

```sh
make collections-publisher
```

👉 [Check the troubleshooting guide if you have a problem.](docs/troubleshooting.md)

Each project provides a number of 'stacks' for different use cases. You can see the stacks for a project in its [config file](projects/content-publisher/docker-compose.yml). To provide consistency, all projects should follow these conventions for stacks:

### The `lite` stack

This stack provides only the minimum number of dependencies to run the project code. This is useful for running the tests, or a Rails console, for example.

Do this to run the tests for a project:

```sh
govuk-docker run collections-publisher-lite bundle exec rake
```

👉 [Check the troubleshooting guide if you have a problem.](docs/troubleshooting.md)

### The `app` stack

This stack provides the dependencies necessary to run an app e.g. in a browser. If the app is a web app, you will then be able to visit it in your browser at `my-app.dev.gov.uk`.

Do this to start a GOV.UK web app:

```sh
govuk-docker up collections-publisher-app
```

👉 [Replicate data locally](docs/how-tos.md#how-to-replicate-data-locally) (or use the [`app-live` stack](#the-app--stacks)).

👉 [Check the troubleshooting guide if you have a problem.](docs/troubleshooting.md)

### The `app-*` stacks

Variations on the `app` stack are allowed where necessary such as:

  - **app-draft**: used for testing the [authenticating-proxy](https://github.com/alphagov/govuk-docker/tree/master/projects/authenticating-proxy) against a draft version of the [router](https://github.com/alphagov/govuk-docker/tree/master/projects/router) app.
  - **app-live**: used to test a read-only frontend app against live GOV.UK APIs (avoids having to replicate data locally).
  - **app-account**: used to enable integrations with a local [account manager app prototype](https://github.com/alphagov/govuk-account-manager-prototype) and [attribute store](https://github.com/alphagov/govuk-attribute-service-prototype/). Currently a part of the [GOV Accounts trial](https://gds.blog.gov.uk/2020/09/22/introducing-gov-uk-accounts/)

Some `app` stacks also depend on a `worker` stack, to run asynchronous tasks [[example](https://github.com/alphagov/govuk-docker/blob/d286748e0300df8f0d1ed618086d4f8f951e752a/projects/content-publisher/docker-compose.yml#L46)].

## Resources

- [Troubleshooting guidance](docs/troubleshooting.md)
- [How-to guidance](docs/how-tos.md)
- [Learning GOV.UK Docker](https://docs.publishing.service.gov.uk/manual/intro-to-docker.html)

## Contributing

Check out the [CONTRIBUTING](CONTRIBUTING.md) guide.

## Licence

[MIT License](LICENCE)
