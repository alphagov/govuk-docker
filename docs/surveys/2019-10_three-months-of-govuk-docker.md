# Three months of GOV.UK Docker Survey

In October 2019 we ran a survey to learn about the experiences of GOV.UK
developers with the then 3 month old GOV.UK Docker development environment.
The survey aimed to learn about the usage of the tool, problem areas people
have experienced, reasons why developers aren't using the tool, the wants
for data replication and impressions on ease-of-use/maintainability of it.

The survey received 33 responses total and free text responses have been
paraphrased for brevity.

## Introduction

### Do you use GOV.UK Docker?

| Answer                                | Responses | Percentage |
|---------------------------------------|-----------|------------|
| Yes, It's how I do all my development | 10        | 30.3%      |
| Yes, it's a key part of my workflow   | 5         | 15.2%      |
| Yes, occasionally                     | 9         | 27.3%      |
| No, I don't use it                    | 9         | 27.3%      |

## Questions for users of GOV.UK Docker

### Does GOV.UK Docker meet your needs for running GOV.UK applications?

| Answer                                | Responses | Percentage |
|---------------------------------------|-----------|------------|
| Absolutely                            | 9         | 37.5%      |
| In some ways, but it's missing things | 15        | 62.5%      |
| Not really                            | 0         | 0%         |

### How could GOV.UK Docker meet more of your needs?

- More data replication functionality (6 responders).
- Not all apps are there (4 responders).
- Easier to use (2 responders).
- Be able to test govuk-puppet locally.
- It would be nice to have some sample data in the databases (eg. a few
  documents in different states).
- Making service ports (eg, elasticsearch) exposed to the host by default
  would be handy.
- To setup Whitehall I needed to run the Publishing API separately or it'd
  fail. To run Whitehall frontend I need to run Static separately or a page
  won't render.

### Are there aspects of GOV.UK Docker that cause you problems?

- Issues running since Ruby upgrade (3 responders).
- Debugging why an app isn't working locally can be difficult.
- Setup of the databases was tricky.
- Sometimes dependant apps fail to start up.
- Workers aren't run by default with an app.
- Initial app build takes time.
- Static has problems running.
- I often get a red failed to connect to service error message.
- It is a little tricky to set up and usually needs a bit of effort to get to
  work.
- The development process could be more transparent.
- Limited documentation for completely new starters.
- It also seems to take up quite a lot of space for each app.
- Troubleshooting difficult as I don't know the docker well.

## Questions for people who don't use GOV.UK Docker

### Why don't you use GOV.UK Docker?

- Mostly run apps on local machine with `--live` flag (3 responders)
- I haven't had the opportunity to. My VM still works.
- I missed firebreak and don't know why we're deprecating the dev VM.
- Every time I come to use it I can never get it running first time. Usually a
  lot of errors and takes a lot of effort to fix them.
- Conflicts with the [bring your own device (BYOD) VPN][byod-vpn-problems].

[byod-vpn-problems]: https://github.com/alphagov/govuk-docker/pull/251#discussion_r344199181

### Have you tried using GOV.UK Docker?

| Answer                                                         | Responses | Percentage |
|----------------------------------------------------------------|-----------|------------|
| I did, it seemed to work                                       | 3         | 33.3%      |
| Yes, but it wasn't working properly                            | 3         | 33.3%      |
| I tried but got stuck at an installation/initial setup problem | 2         | 22.2%      |
| No I haven't                                                   | 1         | 11.1%      |

### Are you interested in using GOV.UK Docker for your development?

| Answer | Responses | Percentage |
|--------|-----------|------------|
| Yes    | 6         | 66.7%      |
| No     | 3         | 33.3%      |

#### Reasons for yes

- Easier to develop locally and is quicker compared to the VM.
- I helped do some of the initial work to get it going, seemed pretty good and
  more usable than the VM.
- If I have to run applications with more dependencies.
- If it solves the problem that you can't use the VM and VPN at the same time.

#### Reasons for no

- Don't understand how it works, how to get some apps running, and then make
  the tweaks to the applications I want to change.
- I work on the data.gov.uk stack which doesn't need GOV.UK Docker.
- Happy with running apps locally with `--live` flag

### Are there things that are needed (or should change) in GOV.UK docker so that is suitable for your usage?

- Data replication
- DGU/CKAN stack
- Mapit
- Reduced disk space usage, another dev said Whitehall disk usage was very high.

## Using GOV.UK data in a development environment

### In your day-to-day development do you need to be working with replica GOV.UK data?

| Answer                                                       | Responses | Percentage |
|--------------------------------------------------------------|-----------|------------|
| Frequently, I can barely work without it                     | 7         | 21.2%      |
| Occasionally, it makes development easier and more realistic | 18        | 54.6%      |
| No, it isn't necessary for my development                    | 7         | 21.2%      |
| I don't run GOV.UK apps locally                              | 1         | 3%         |

#### Reasons to need data

- Working out solutions to bug reports is much easier when you can use the
  exact data that may be causing issues (6 responders).
- Working with search requires accurate data (6 responders)
- Need to run Whitehall locally (5 responders).
- I've never really tried to do application development without it.
- Most of the logic I'm writing is working on data.
- Wanting an accurate list of taxons/contacts/organisations/people to service
  Publishing API linkables

#### Reasons to not need data

- I use the live endpoints to get the data (3 responders).
- When developing new features I don't really need the exact data, but it
  saves time if something is already set up.
- I'm not usually working in apps which have data, and if they do, I can easily
  create my own test cases locally. If I'm working on things which require
  specific users data, I just use integration.
- I find I can get by with just a handful of manually created key records that
  are necessary to get something working.
- I don't remember needing data to do any work on Platform Health.

### In recent months what apps, if any, have you needed replicated GOV.UK data for your development?

- Whitehall (12 responders)
- Publishing API (6 responders)
- Search API (6 responders)
- Content Store (4 responders)
- Collections Publisher
- Content Data Admin
- Content Publisher
- Email Alert API
- Smart Answers

### What would be, if any, your preferred approach to importing data?

| Answer                                                                                                                                | Responses | Percentage |
|---------------------------------------------------------------------------------------------------------------------------------------|-----------|------------|
| Importing data when needed for a single application (for example different imports for Publishing API, Whitehall, Content Store, etc) | 24        | 72.7%      |
| A single, long process that imported data for every GOV.UK app (as per the dev VM)                                                    | 1         | 3%         |
| Other                                                                                                                                 | 8         | 24.3%      |

#### Other suggestions

- The option to choose between the two
- An automatic process to get data for the app working on and it's dependent
  apps.
- I don't know. One-by-one sounds better, but there seems to be a difference
  between importing data for API apps vs. user-facing apps.
- Depends on situation but it would seem to be sensible to do it on a per-app
  basis.
- A mix of the two - a long process command with options to allow us to
  dictate specific apps if we wish to.
- Import data as needed, including offering subset of data for basic running.
- The dev VM allows importing per database, which seems an ok solution to me.
- Importing data when needed for a single application with an option to import
  just part of the data would be ideal.

## Development VM

### Do you use the Development VM?

| Answer                              | Responses | Percentage |
|-------------------------------------|-----------|------------|
| Yes, it's a key part of my workflow | 4         | 12.1%      |
| Yes, occasionally                   | 11        | 33.4%      |
| No, I don't use it                  | 18        | 54.5%      |

### Does the Development VM meet any needs for you that GOV.UK Docker does not?

- Using apps not ported (4 responders)
- Data replication (3 responders)
- Testing govuk-puppet (3 responders)
- Sidekiq UI
- Rabbit MQ UI
- Easier to access every aspect of system
- Combined logging output
- Debugging Whitehall

### Would the deletion of the Development VM cause you any current problems?

| Answer | Responses | Percentage |
|--------|-----------|------------|
| Yes    | 13        | 39.4%      |
| No     | 20        | 60.6%      |

### What concerns might you have regarding the deletion of the Development VM?

- Docker doesn't work for every app (3 responders)
- Losing ability to test govuk-puppet (2 responders)
- Updating postcode data for Mapit (2 responders)
- Lack of fallback for when GOV.UK Docker doesn't work (2 responders)
- Edge cases we're not aware of where Dev VM is necessary
- Starting up dependencies is a lot harder in GOV.UK Docker with different
  stack names.

## Reflecting on GOV.UK Docker

### Do you think it would be easy for someone new to GOV.UK could get started with GOV.UK Docker?

| Answer                                            | Responses | Percentage |
|---------------------------------------------------|-----------|------------|
| Yes, with minimal help                            | 12        | 36.4%      |
| Yes, as long as they had someone to help          | 11        | 33.3%      |
| No, it would not be easy                          | 2         | 6.1%       |
| I don't know enough about GOV.UK Docker to answer | 8         | 24.2%      |

### What changes would make GOV.UK docker easier for someone new to GOV.UK?

- Good documentation (3 responders)
- More troubleshooting guidance (3 responders)
- Suggested resources on how to learn Docker.
- Make Dnsmasq setup easier.
- Start with assumption user hasn't used Ruby before.
- Remove govuk-docker wrapper script.
- One step install.
- Choose between scripted setup or manual instructions, we have both.
- Reduce/automate the amount of repo cloning to get started.

### On a scale of 1 to 5 how confident are you that GOV.UK developer community can maintain and iterate GOV.UK Docker as part of the wider GOV.UK development environment?

| Answer | Responses | Percentage |
|--------|-----------|------------|
| 1      | 1         | 3%         |
| 2      | 3         | 9%         |
| 3      | 12        | 36.4%      |
| 4      | 12        | 36.4%      |
| 5      | 5         | 12.2%      |

#### Reasons for low confidence

- No dedicated owners or team responsible for it (6 responders)
- It doesn't seem to be particularly dependable, things working previously
  can break.
- A lack of experienced people to review changes.

#### Reasons for neutral confidence

- Small number of people who are enthusiastic about maintaining it, were they
  to leave it could become unmaintained.
- There is momentum but I'm concious that we leave things unfinished and then
  move on.
- Only those who are actively involved in its development are going to know
  how to maintain and iterate it.
- General lack of knowledge in underlying docker/compose technology.
- Concern that live environments become very different to docker ones
- It's easier than maintaining the VM but I don't know if people will have
  time to work on it.

#### Reasons for high confidence

- I'm experiencing way less issues than with the VM.
- Current dev team have a good knowledge following the firebreak.
- Codebase nice and clean.
- If we kill the dev vm then we won't have a choice but to maintain it.

### Finally, do you have thoughts or ideas on improving GOV.UK Docker or the wider GOV.UK development experience that haven't been already captured?

- Less custom CLI (2 responders).
- A team dedicated to development experience.
- More automated checks.
- Replicating data.
- Unifying govuk-docker and application main Dockerfiles.
- Devs provided with more time to work on it.
- Docker training.
- Documentation on CPU/RAM requirements.
- Less stuff built whenever build command runs.
