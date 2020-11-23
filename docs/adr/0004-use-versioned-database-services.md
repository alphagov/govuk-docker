# 1. Use versioned database services

Date: 2020-11-23

## Context

GOV.UK Docker has services defined for various databases, such as PostgreSQL,
MongoDB and Elasticsearch. These have their data persisted in
[Docker volumes][volume] defined [for each service][defined-volumes].

When GOV.UK Docker updated from [MongoDB 2.4 to 3.6][mongodb-update] users
began receiving cryptic errors when trying to run applications that depended
on MongoDB. This was because they had a volume with data structured for MongoDB
2.4 whereas MongoDB was expecting this to be structured for 3.6.

We felt that this upgrade path was more confusing and difficult than it needed
be and wanted to improve it for the future.

[volume]: https://docs.docker.com/storage/volumes/
[defined-volumes]: https://github.com/alphagov/govuk-docker/blob/cb124a3a1d3353e777d4f777d77f03f93415d415/docker-compose.yml#L5-L10
[mongodb-update]: https://github.com/alphagov/govuk-docker/pull/356

## Decision

We decided that we would rename database services, and their respective
volumes, to reflect the software version number. For example the `mongo`
service, and namesake volume, have been renamed to `mongo-3.6`.

The precision of the version number is chosen based on the backwards
compatibility between versions of the software. For example to upgrade from
MySQL 5.5 to 5.6 requires an upgrade script and thus would cause problems for
GOV.UK Docker users. However, upgrading from 5.5.58 to 5.5.59 does not. For
services that aren't sensitive to minor versions, such as Elasticsearch, we
have specified the service and volume with respective to a major version:
`elasticsearch-6`.

## Status

Accepted

## Consequences

When we next update the version of a database service in GOV.UK Docker users
will find they have an empty volume for that database rather than one with
incompatible data. This will make it easier for developers to work with the
service as they can run the familiar `make <service>` task to re-initialise it
(or refill it with replica data, using [the replication scripts][]).

Advanced users will have the option to maintain their existing data by
migrating data from the old volume to the new volume. We decided not to
provide guidance for this, as we think most local data is low value and not
worth the effort to maintain.

GOV.UK Docker is prepared to run multiple versions of a database service to
allow some applications in the stack to run a newer version while others
continue to use an old one, should a need arise.

[the replication scripts]: https://github.com/alphagov/govuk-docker/tree/master/bin
