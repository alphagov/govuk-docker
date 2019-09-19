[NEEDS]: 0001/NEEDS.md
[DECISIONS]: 0001/DECISIONS.md

# 1. Record architecture decisions

Date: 2019-09-19

## Context

We need to record the architectural decisions made on this project.

The [original govuk-docker repo](https://github.com/benthorner/govuk-docker) was written outside of GOV.UK. Major architectural decisions, as well as more minor decisions, were written as [documentation in the repo][DECISIONS], together with their associated user [NEEDS]. While these documents have historical value, they are not being maintained and increasingly differ from the current state of the repo. As part of adopting an ADR approach, we should clearly deprecate these historical documents to avoid confusion.

## Decision

We will use Architecture Decision Records, as described by Michael Nygard in this article: http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions

## Status

Accepted

## Consequences

See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's _adr-tools_ at https://github.com/npryce/adr-tools.

We will deprecate the historical [DECISIONS] and [NEEDS] documents, by writing a deprecation notice at the top of each document, and by moving them into the assets for this ADR.
