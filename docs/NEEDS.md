[make-1]: DECISIONS.md#make-1
[make-2]: DECISIONS.md#make-2

# Needs

This is a thorough but non-exhaustive list of the needs for developing in the GOV.UK ecosystem. All of the needs should be independent of the decisions that try to address them, which is why none refer to govuk-docker specifically.

Format:

>**As a** developer on <br>
>**I want** <br>
>**So that** <br>

Using the word 'service' instead of 'app' is a reminder that the GOV.UK ecosystem includes libraries, as well as runnable apps. Where a need is specific to an app, which is usually a web app, the word 'app' is used instead.

### Learning GOV.UK

>**As a** new developer on GOV.UK <br>
>**I want** to quickly get all the active GOV.UK repos <br>
>**So that** I can work with them locally <br>

Decisions made to support this need: [make-clone](DECISIONS.md#make-clone)

>**As a** new developer on GOV.UK <br>
>**I want** to understand how the services are connected <br>
>**So that** I can understand the service I'm working on <br>

Decisions made to support this need: [docker-compose](DECISIONS.md#docker-compose)

>**As a** new developer on GOV.UK <br>
>**I want** to understand the dev tools I'm using <br>
>**So that** I can use them correctly and debug issues <br>

Decisions made to support this need: [make-files](DECISIONS.md#make-files), [docker-compose](DECISIONS.md#docker-compose), [cli-echo](DECISIONS.md#cli-echo), [docker-binding](DECISIONS.md#docker-binding)

### Getting Started

>**As a** new developer on a GOV.UK service <br>
>**I want** to setup my environment without help <br>
>**So that** I don't feel like a burden on my team <br>

Decisions made to support this need: [make-idempotent](DECISIONS.md#make-idempotent)

>**As a** new developer on a GOV.UK service <br>
>**I want** to install the packages for the service <br>
>**So that** I can run service commands (e.g. rake) <br>

Decisions made to support this need: [docker-dockerfiles](DECISIONS.md#docker-dockerfiles), [docker-context](DECISIONS.md#docker-context), [make-files](DECISIONS.md#make-files), [docker-stacks](DECISIONS.md#docker-stacks)

>**As a** new developer on a GOV.UK app <br>
>**I want** to initialise the databases for the app <br>
>**So that** I can run the test suite that uses them <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [make-files](DECISIONS.md#make-files)

>**As a** new developer on a GOV.UK app <br>
>**I want** to initialise the databases for the app <br>
>**So that** I can manually test the app (e.g. in browser) <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [make-files](DECISIONS.md#make-files)

>**As a** developer on GOV.UK who has moved teams<br>
>**I want** to be able to get all of the new apps I will be working on, and their dependencies, with minimal typing<br>
>**So that** I can get up to speed more quickly<br>

Decisions made to support this need: [cli-setup](DECISIONS.md#cli-setup)

### Getting Updates

>**As a** developer on a GOV.UK service <br>
>**I want** to install the latest packages for the service <br>
>**So that** I can continue to run service commands <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [docker-lockfiles](DECISIONS.md#docker-lockfiles), [docker-bundle](DECISIONS.md#docker-bundle), [cli-runthis](DECISIONS.md#cli-runthis)

>**As a** developer on a GOV.UK service <br>
>**I want** to install the language version for the service <br>
>**So that** I can continue to run service commands <br>

Decisions made to support this need: [docker-imagetag](DECISIONS.md#docker-imagetag), [cli-buildthis](DECISIONS.md#cli-buildthis)

>**As a** developer on GOV.UK services <br>
>**I want** to get/update all active GOV.UK repos <br>
>**So that** I can search across all codebases <br>

Decisions made to support this need: [make-idempotent](DECISIONS.md#make-idempotent), [make-clone](DECISIONS.md#make-clone)

### Running Services

>**As a** developer on a GOV.UK app <br>
>**I want** to start a web server for the app <br>
>**So that** I can manually test the app <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [docker-bindmount](DECISIONS.md#docker-bindmount), [docker-binding](DECISIONS.md#docker-binding)

>**As a** developer on a GOV.UK app <br>
>**I want** to navigate to the app in my browser <br>
>**So that** I can manually test the app <br>

Decisions made to support this need: [web-nginx](DECISIONS.md#web-nginx), [web-dnsmasq](DECISIONS.md#web-dnsmasq)

>**As a** developer on a GOV.UK app <br>
>**I want** to run the app against supporting APIs <br>
>**So that** I can manually test the app <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [web-nginx](DECISIONS.md#web-nginx), [make-setup](DECISIONS.md#make-setup)

>**As a** developer on a GOV.UK app <br>
>**I want** to run the app against an end-to-end stack <br>
>**So that** I can manually test user journeys <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [web-nginx](DECISIONS.md#web-nginx), [make-setup](DECISIONS.md#make-setup), [rails/rails#36486](https://github.com/rails/rails/pull/36486)

>**As a** developer on a GOV.UK app <br>
>**I want** to run the app against a draft-specific stack <br>
>**So that** I can manually test user journeys <br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [web-nginx](DECISIONS.md#web-nginx), [make-setup](DECISIONS.md#make-setup), [rails/rails#36486](https://github.com/rails/rails/pull/36486)

>**As a** developer on a GOV.UK app <br>
>**I want** to change code without restarting the server <br>
>**So that** I can efficiently assess the outcome <br>

Decisions made to support this need: [docker-mount1](DECISIONS.md#docker-mount1)

>**As a** developer on a GOV.UK app <br>
>**I want** to run an debugger in the web server <br>
>**So that** I can investigate a bug <br>

Decisions made to support this need: [docker-debugger](DECISIONS.md#docker-debugger)

>**As a** developer on a GOV.UK service <br>
>**I want** to run a service-specific task (e.g. rake task) <br>
>**So that** I can manually test the task<br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [cli-env](#DECISIONS.md#cli-env)

>**As a** developer on a GOV.UK service <br>
>**I want** to view the logs for the service <br>
>**So that** I can investigate a bug (e.g. in a test)<br>

Decisions made to support this need: [docker-mount1](DECISIONS.md#docker-mount1)

>**As a** developer on a GOV.UK service<br>
>**I want** to edit service dependencies<br>
>**So that** I can investigate a bug<br>

### Automating Tests

>**As a** developer on a GOV.UK service <br>
>**I want** to run the entire test suite <br>
>**So that** I can test the service works<br>

Decisions made to support this need: [docker-dockerfiles](DECISIONS.md#docker-dockerfiles), [docker-bindmount](DECISIONS.md#docker-bindmount), [cli-runthis](DECISIONS.md#cli-runthis)

>**As a** developer on a GOV.UK service <br>
>**I want** to run a debugger in the tests <br>
>**So that** I can investigate a bug <br>

Decisions made to support this need: [docker-debugger](DECISIONS.md#docker-debugger)

>**As a** developer on a GOV.UK service <br>
>**I want** to run one or more specific tests<br>
>**So that** I can efficiently test changes<br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks), [cli-runthis](DECISIONS.md#cli-runthis)

>**As a** developer on a GOV.UK service <br>
>**I want** to write tests that behave predictably<br>
>**So that** I can be confident they will pass on CI<br>

Decisions made to support this need: [docker-stacks](DECISIONS.md#docker-stacks)

>**As a** developer on a GOV.UK service <br>
>**I want** to test a change spread over multiple services <br>
>**So that** I can verify the services all work together <br>

Decisions made to support this need: [docker-mount2](DECISIONS.md#docker-mount2)

### Other Needs

>**As a** developer on a non-GOV.UK service <br>
>**I want** to not use a GOV.UK-specific environment <br>
>**So that** I can run non-GOV.UK service commands <br>

Decisions made to support this need: [cli-exists](DECISIONS.md#cli-exists)

>**As a** developer on a GOV.UK service <br>
>**I want** to run commands with minimal typing <br>
>**So that** I can develop more efficiently <br>

Decisions made to support this need: [make-setup](DECISIONS.md#make-setup), [cli-exists](DECISIONS.md#cli-exists), [cli-runthis](DECISIONS.md#cli-runthis), [cli-aliases](DECISIONS.md#cli-aliases), [cli-buildthis](DECISIONS.md#cli-buildthis), [docker-bundleexec](DECISIONS.md#docker-bundleexec)

### Contributing

>**As a** developer on a new GOV.UK service <br>
>**I want** to update my environment to support it <br>
>**So that** I can meet all of my other needs <br>

Decisions made to support this need: [make-clone](DECISIONS.md#make-clone), [make-files](DECISIONS.md#make-files), [docker-compose](DECISIONS.md#docker-compose)

>**As a** developer on a changing GOV.UK service <br>
>**I want** to update my environment to support it<br>
>**So that** I can meet all of my other needs <br>

Decisions made to support this need: [make-files](DECISIONS.md#make-files), [docker-compose](DECISIONS.md#docker-compose), [docker-aliases](DECISIONS.md#docker-aliases)
