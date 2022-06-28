# CONTRIBUTING

Contributions welcome - just raise a PR and make sure the tests pass!

## Testing

GOV.UK Docker tests are written in Ruby / RSpec. Just like any other Ruby project, we have a `govuk-docker-lite` stack for running the tests, using GOV.UK Docker.

Do this the first time you run the tests:

```sh
make govuk-docker
```

Do this to run the tests for GOV.UK Docker:

```sh
make test-local
```

This will also run checks on scripts and config files in this repo. Since these checks require access to your local machine, they are not run using GOV.UK Docker.

## Versioning

GOV.UK Docker is [versioned][version] in order to notify users about important changes, where they may need to take action. Since we use the repo itself for distributing GOV.UK Docker, for many PRs it's unlikely you will need to change the version.

> A consequence of this is that GOV.UK Docker does *not* (need to) follow [semantic versioning][semver].

Any change to the [version][] should be accompanied with an explanation in the [CHANGELOG][]. When the [version][] changes, a user running the `govuk-docker` CLI will see a one-time notification, which includes the new [CHANGELOG][] entry.

[version]: exe/govuk-docker-version
[CHANGELOG]: CHANGELOG.md
[semver]: https://semver.org/
