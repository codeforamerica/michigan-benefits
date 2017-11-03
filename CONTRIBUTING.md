# Contributing

This document outlines how to get the application set up
and how we continuously ship working software.

## External Contributions

This document outlines the process for members of the Code for
America development team and other partners.

While this project is open source,
we are not currently seeking external contributions.
If you would like to learn more about this project,
please email <alanw@codeforamerica.org>.

## Getting Set Up

### Ruby on Rails

This application is built using [Ruby on Rails].

Your system will require [Ruby] to develop on the application.

The required Ruby version is listed in the [.ruby-version](.ruby-version) file.

If you do not have this binary, [use this guide to get set up on MacOS].

[Ruby on Rails]: http://rubyonrails.org
[Ruby]: https://www.ruby-lang.org/en/
[use this guide to get set up on MacOS]: http://installfest.railsbridge.org/installfest/macintosh

### Configuring the Application

* After cloning this repo, run: `bin/setup`.

### Onboarding Checklist

Ask the team for access to the following services to begin contributing:

* GitHub
* Slack
* Twilio
* Mailgun
* Trello (2 boards)
* Heroku
* Password Manager
* Get calendar invites to: daily standup, weekly planning, weekly retro


## Day-to-day Development

### Local Server

* Run the server(s): `foreman start`
* Visit [your local server](http://localhost:3000)
* To preview any emails that were sent while testing locally, visit the [running mailcatcher instance](http://localhost:1080/)
* Run tests and Rubocop: `rake`

### Conventions
* **Secrets** - api keys and secrets should be placed in `config/secrets.yml` and
  referenced via Rails' secrets api. Eg: `Rails.application.secrets.an_api_key`.


### Step Navigation

This application is a long questionnaire.
You will probably want to work on parts of it
without completing the whole application.

After booting the server and filling out the first step,
go to `http://localhost:3000/steps`
to jump around.


### Testing

#### Spec Helpers

* Use `with_modified_env` to modify an env variable for one test:

```ruby
with_modified_env INVITATION_CODE: "inv-code", INVITATIONS_ENABLED: "true" do
  post :create, user: { name: "Alice", invitation_code: "wrong-code" }
  expect(flash[:alert]).to equal "Invalid invitation code"
end
```

* Use `match_html` to test that two HTML strings match, excluding whitespace, order of attributes, etc.:

```ruby
expect(rendered).to match_html <<-HTML
  <table class="foo bar">
  <tr>
  <td>Hi!</td>
  </tr>
  </table>
HTML
```

### Document / Photo Uploading Details

* The file uploading service is called [Shubox]. The [dashboard] can be
accessed with account info found in 1password. Contact [@jayroh] for any
questions or issues related to Shubox.
* The file limit is currently set to 8MB. That can be bumped up if we notice
that people are often taking photos or attaching documents larger than that.
* The file formats currently allowed as "Documents" consist of:
  * .gif
  * .jpg
  * .pdf
  * .png

[Shubox]: https://shubox.io
[dashboard]: https://dashboard.shubox.io
[@jayroh]: https://github.com/jayroh

### Admin dashboard

Our admin dashboard is built with [administrate].

In order to access the admin dashboard in any environment, you'll need an
`AdminUser` account.

To add new users on staging and production, those with Heroku access can create
accounts via Heroku console. Example:

```
heroku run rails c -r staging
AdminUser.create!(email: "jessie@example.com", password: SecureRandom.base64)
```

If you are creating an account for someone else, you can instruct them to visit
`/admin_users/password/new` (eg:
https://staging.michiganbenefits.org/admin_users/password/new) and enter their
email address. Submitting the form on that page triggers a password reset email.

[administrate]: https://github.com/thoughtbot/administrate

### Deploying

See [DEPLOYING.md](DEPLOYING.md)

## Workflow

NOTE: See [DESIGN-README.md](DESIGN-README.md) for design-specific
resources and workflow.

### Planning

* A change is initiated and discussed via a
  [Trello](https://trello.com/b/aBqTrqaJ/michiganbridgesorg) card.
* All new Trello cards are added to the "Inbox" Trello list.
* During a weekly planning meeting, prioritized Trello cards are added to the
  "This week" Trello list. Cards in this list should have enough detail to be
  actionable. Top priority items are at the top of the list.
* During the team's weekly retro meetings, feedback about the workflow is noted
  and related changes are incorporated into this document.


### Bugs

A problem is first noticed, e.g. Alert comes in, team member pings us "I haven't seen text messages coming in over the weekend. Something might be wrong."
Person who noticed the problem, writes a ticket with a "Bug Triage" label and puts it at the top of the Up Next column.

An engineer taking the next ticket will triage the ticket. They investigate it, add some description of the problem. The purpose of this investigation is to
figure out when it should be worked on.

#### Apply the correct Trello label

| Label      | Severity | Action |
| ------------- | -----------| ----- |
| P1 | Sever bug. (e.g. the site is down, apps are at risk of not being delivered) | Should be fixed immediately |
| P2 | Some negative impact on users | Should be placed on top of Ready column (PM may increase priority) |
| P3 | No big impact, low priority | Place in backlog |

### Work In Process

* When someone starts working on a task, they move the Trello card into "In
  Progress" and assign themselves so that others know they are working on it.
* All code is written on a branch *other* than `master`. The team is not picky
  about branch naming.

### Debugging

* Call `binding.pry` anywhere in the code to stop execution and get a debugger console.
* Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.
* To get a good look at and debug any emails that were sent from your running
development environment visit your local [mailcatcher server](http://localhost:1080/).


### Code Review

* A Pull Request (PR) is created on GitHub. All PRs should have [a good commit
  message](https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message).
[The PR is attached to the related Trello
card](https://blog.trello.com/github-and-trello-integrate-your-commits).
* The PR Author can request reviews via GitHub's [request a pull request
  review](https://help.github.com/articles/requesting-a-pull-request-review/)
feature. In general, the team prioritizes code reviews over other work.
* Before a PR can be merged into `master` it must:
  * Have been QA'd locally by the PR author.
  * Pass checks for Circle CI (these can be seen in the PR itself via GitHub webhooks).
  * Have the explicit approval of one or more teammates via GitHub's approval
    feature.

### Merging

* By default, it is expected that the PR author will merge when ready. In some
  cases, a reviewer may merge if merging is time-sensitive or the author is
  unavailable to merge for some reason.
* Whoever merges a branch into `master` deletes the branch after merging.
* Merged code is automatically deployed to the [staging
  environment](https://michigan-benefits-staging.herokuapp.com/) after a green
build on Circle CI.
* When two people are pairing on something, code can be merged to `master`
  without an explicit PR / code review process.

### Acceptance Testing

* Before deploying to production, we ask a teammate who _did not_ work on the feature to test our change on staging.
* Ideally, the story author has put explicit acceptance steps into the card.
* Assign yourself to the card, so others know you're testing.
* Spin up staging and follow the acceptance tests.
* If all looks well, move to the "Done" column.
* If you have a question, ask it in the card and label the card "Blocked".
* If not, comment as to why and bump back to "In Process".

#### Testing Document Uploads on Staging

NOTE: Document upload via [Shubox] on staging requires using this URL:

[http://staging.michiganbenefits.org](http://staging.michiganbenefits.org)

and will not work on this URL:

[https://michigan-benefits-staging.herokuapp.com](https://michigan-benefits-staging.herokuapp.com)

## Driving Applications on MIBridges.org

After clients complete our application form,
      we use web driver software to fill in values
      on the [MIbridges.org](http://mibridges.org) application.


### Requirements

1. A sufficiently complete `SnapApplication`
2. Chrome and Chromedriver are installed (the latest versions). `./bin/setup`
should get this set up for you automatically.

### How to Drive Applications

To run the driver code, use `bin/drive <id>` (where
`<id>` is the id of a snap application record):

There are three extra environment variables you can set to modify the behavior
of the script.

| Variable      | Purpose |
| ------------- | -----------|
| `WEB_DRIVER=chrome` | If you would like it to run in a FULL chrome browser instead of the headless version |
| `DRIVER_SPEED=slow` or `medium` | If you'd like it to run a little slower, perhaps for demo purposes or to look more "human" |
| `DEBUG_DRIVE=true` | If you would like to display a log of some of the things happening as it "drives" |

Example:

```sh
DRIVER_SPEED=slow \
  WEB_DRIVER=chrome \
  DEBUG_DRIVE=true \
  bin/drive 1234
