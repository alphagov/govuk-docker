# 3. Use Docker volumes for improved macOS performance

Date: 2020-11-23

## Context

A common problem developers have experienced with GOV.UK Docker is that the
[asset pipeline][] compilation steps can be slow, to the point that it was once
common that users [were served 504 responses][504-fix] on initial attempts to
start an application. This slowness in GOV.UK Docker appeared to be an
amplification of [existing performance][govuk-frontend-performance] issues,
however when GOV.UK apps began upgrading from the end-of-life Ruby Sass to
Sassc we also began to see problems that pointed to a performance issue
within GOV.UK Docker.

Sassc is known to [significantly improve the compilation time][sassc-speed] of
Sass compared to Ruby Sass. When we updated [Content Publisher][] to Sassc we
found that the [application.scss][] file compiled in 20% of the time (~20s to
4s) when running natively on macOS. However when this was run on GOV.UK Docker
the performance was significantly less impressive, compiling in 62% of the
time (~31s to ~19s).

We discovered that the source of this performance issue was the
[performance overhead of reading][docker-mac-read] from the
[shared mount][govuk-mount] of application files on macOS. In particular we
found that there were directories, `tmp` and `node_modules`, which could be
frequently accessed during Sass compilation, but did not contain
files that a developer would need to edit during development. Bearing this in
mind, we considered a number of options as to how we could improve the
performance:

1. Use [Docker volumes][volume] to store non-application code (such as `tmp`
   and `node_modules`) to benefit from faster I/O access.
2. [Configure GOV.UK Docker to use NFS][nfs-docker] (an alternative driver for
   shared mounts) for improved I/O access to shared mounts.
3. Use [docker-sync.io](http://docker-sync.io/) (a file-syncing daemon) as a
   means for improved I/O access to shared mounts.

[asset pipeline]: https://guides.rubyonrails.org/asset_pipeline.html
[504-fix]: https://github.com/alphagov/govuk-docker/pull/310
[govuk-frontend-performance]: https://github.com/alphagov/govuk-frontend/issues/1671
[sassc-speed]: https://www.solitr.com/blog/2014/01/css-preprocessor-benchmark/
[Content Publisher]: https://github.com/alphagov/content-publisher
[application.scss]: https://github.com/alphagov/content-publisher/blob/2f91d43bcd1eb1f2d30f9d1ff9e556cd4d0de2a6/app/assets/stylesheets/application.scss
[docker-mac-read]: https://github.com/docker/for-mac/issues/77
[govuk-mount]: https://github.com/alphagov/govuk-docker/blob/cb124a3a1d3353e777d4f777d77f03f93415d415/projects/content-publisher/docker-compose.yml#L11
[volume]: https://docs.docker.com/storage/volumes/
[nfs-docker]: https://www.jeffgeerling.com/blog/2020/revisiting-docker-macs-performance-nfs-volumes

## Decision

We decided to mount project-specific Docker volumes on top of the existing
`~/govuk` shared mount, in order to store non-application code (caches or
dependencies).

When trying this on Content Publisher, with the `tmp` directory and
`node_modules` directory as Docker volumes, we saw a significant improvement
in Sass compilation time on macOS:

| Environment                                           | Ruby Sass | Sassc | Decrease |
|-------------------------------------------------------|-----------|-------|----------|
| Native macOS                                          | ~20s      | ~4s   | 80%      |
| GOV.UK Docker (with shared `~/govuk` mount)           | ~31s      | ~19s  | 38%      |
| GOV.UK Docker (with `tmp` and `node_modules` volumes) | ~16s      | ~4s   | 75%      |

We saw less impressive improvements by switching the shared mount to use NFS.
This performed approximately 3 times slower than the Docker volume approach.
This approach was also not desirable as it required configuration on the host
machine to create the NFS directory which would complicate installation and
usage of GOV.UK Docker.

We decided not to use docker-sync.io as that required additional dependencies
and a large amount of additional configuration. We felt that, given Docker
volumes provided us with near native performance, it would not be worth
pursuing an unconventional, configuration heavy, approach.

## Status

Accepted

## Consequences

We have added Docker volumes to the configuration of all GOV.UK Rails projects
so that the `tmp` directory is a volume. This provides improved I/O access to
this directory and offers performance benefits outside of Sass compilation
(for example [ActiveStorage][]). To ensure this is applied consistently we
have [added a test][tmp-test].

For projects that make use of npm modules we have added a `node_modules` volume
to the project, which is also [enforced by a test][node-test]. This prevents
developers from sharing npm modules between a host machine and
GOV.UK Docker, which may cause some confusion for any developers that relied
upon running `npm install` or `yarn install` on their host machine. This does,
however, offer the benefit of removing a compatibility risk where module
installations are coupled to a specific OS.

In order to make increased usage of Docker volumes we had to change the base
Dockerfile from [running as a specific user][specific-user] to the Docker
default of running as root. This is because it is [difficult and
complex][volume-root] to define volumes as owned by a different
user. This changes meant that all users of GOV.UK Docker needed to rebuild
their images to accommodate this change. It also slightly increased the
[complexity in running Google Chrome][chrome-root] as part of an application's
system tests. Applications now need to specify that Google Chrome runs as
a "no sandbox" user, which has been done centrally in
[govuk-test][govuk-test-pr].

[ActiveStorage]: https://github.com/alphagov/content-publisher/blob/2f91d43bcd1eb1f2d30f9d1ff9e556cd4d0de2a6/config/storage.yml#L3
[tmp-test]: https://github.com/alphagov/govuk-docker/pull/394/commits/744eed8f655b0bfb793e7f0b57b585b39e126f64
[node-test]: https://github.com/alphagov/govuk-docker/pull/394/commits/8a3d4ee33fb79072da1f0c82eef56a74cdb5781e
[specific-user]: https://github.com/alphagov/govuk-docker/blob/cb124a3a1d3353e777d4f777d77f03f93415d415/Dockerfile.govuk-base#L40-L42
[volume-root]: https://github.com/docker/compose/issues/3270
[chrome-root]: https://stackoverflow.com/questions/12258086/how-do-i-run-google-chrome-as-root
[govuk-test-pr]: https://github.com/alphagov/govuk_test/pull/31
