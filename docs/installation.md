# Installation

## Prerequisites

govuk-docker has the following dependencies:

- [brew](https://brew.sh/)
- [git](https://git-scm.com)
- [Ruby](#how-to-install-or-update-ruby)
- A directory `~/govuk` in your home directory

All other dependencies will be installed for you automatically.

## Setup

Start with the following in your bash config.

```
export PATH=$PATH:~/govuk/govuk-docker/exe
```

Now in the `~/govuk` directory, run the following commands.

```
git clone git@github.com:alphagov/govuk-docker.git
cd govuk-docker
bundle install
bin/setup
```

You can now [setup and run the apps you need](../README.md#Usage), after which you can do things like run tests and startup the app in your browser. If this doesn't work for whatever reason, follow the [instructions on how to resolve setup issues](#troubleshooting).

### Docker settings

Running GOV.UK applications can be resource intensive. To give Docker more resources on Mac, click the Docker whale icon in the macOS menu bar, select 'Preferences'. We suggest the following minimum resources:

* 6 CPUs
* 12 GB RAM
* 64GB+ Disk

### Shortcuts

Typing the [full commands](../README.md#usage) is likely to get tiring. We've added a couple of lightweight helper scripts alongside govuk-docker, which figure out the application you're running based on the name of the current directory.

```
# full commands
govuk-docker run content-publisher-lite bundle exec rake
govuk-docker up content-publisher-app

# shortcuts
# assuming you're in the content-publisher directory
govuk-docker-run bundle exec rake
govuk-docker-up
```

Here are some suggested aliases that make things even shorter.

```
alias gd="govuk-docker"
alias gdr="govuk-docker-run"
alias gdu="govuk-docker-up"
alias gdbe="govuk-docker-run bundle exec"
```

### Environment variables

Both govuk-docker and the Makefile respect the following environment variables:

- `$GOVUK_ROOT_DIR` - directory where app repositories live, defaults to `$HOME/govuk`
- `$GOVUK_DOCKER_DIR` - directory where the govuk-docker repository lives, defaults to `$GOVUK_ROOT_DIR/govuk-docker`
- `$GOVUK_DOCKER` - path of the govuk-docker script, defaults to `$GOVUK_DOCKER_DIR/bin/govuk-docker`

## Troubleshooting

👉 [Check the troubleshooting guide if you have a problem.](docs/troubleshooting.md#troubleshoot-installation)
