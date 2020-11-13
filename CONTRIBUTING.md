# CONTRIBUTING

Contributions welcome - just raise a PR and make sure the tests pass!

## Testing

**First make sure you have the following dependencies.**

- [rbenv](https://github.com/rbenv/rbenv#installation)

**Next install Ruby and the gems required for testing.**

```sh
rbenv install
gem install bundler
bundle install
```

**Now use one of the following commands to run tests.**

```sh
# runs all the tests (see Makefile)
make test

# runs just the Ruby tests in spec/
bundle exec rspec
```

## Versioning

GOV.UK Docker is [versioned][version] in order to notify users about important changes, where they may need to take action. Since we use the repo itself for distributing GOV.UK Docker, for many PRs it's unlikely you will need to change the version.

> A consequence of this is that GOV.UK Docker does *not* (need to) follow [semantic versioning][semver].

Any change to the [version][] should be accompanied with an explanation in the [CHANGELOG][]. When the [version][] changes, a user running the `govuk-docker` CLI will see a one-time notification, which includes the new [CHANGELOG][] entry.

[version]: exe/govuk-docker-version
[CHANGELOG]: CHANGELOG.md
[semver]: https://semver.org/
