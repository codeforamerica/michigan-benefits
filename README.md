# Michigan Benefits

[![CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits.svg?style=svg)](https://circleci.com/gh/codeforamerica/michigan-benefits)
[![Code Climate](https://codeclimate.com/github/codeforamerica/michigan-benefits/badges/gpa.svg)](https://codeclimate.com/github/codeforamerica/michigan-benefits)
[![Test Coverage](https://codeclimate.com/github/codeforamerica/michigan-benefits/badges/coverage.svg)](https://codeclimate.com/github/codeforamerica/michigan-benefits/coverage)

* [GitHub](https://github.com/codeforamerica/michigan-benefits)
* [Trello](https://trello.com/b/aBqTrqaJ/the-digital-assister)
* [Trello - product](://trello.com/b/aBqTrqaJ/the-digital-assister)
* [InVision](https://projects.invisionapp.com/d/main#/projects/prototypes/10425326)
* [CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits)
* [Staging (staging.michiganbenefits.org, not the herokuapp url)](https://staging.michiganbenefits.org)
* [Production](https://michigan-benefits-production.herokuapp.com)
* [Prototype demo](https://michigan-benefits-prod.herokuapp.com/)

## Deploying

### Requirements

* pdftk - see [https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack](https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack)

## Developing

### Ruby on Rails

This application is built using [Ruby on Rails].

Your system will require [Ruby] to develop on the application.

The required Ruby version is listed in the [.ruby-version](.ruby-version) file.

If you do not have this binary, [use this guide to get set up on MacOS].

[Ruby on Rails]: http://rubyonrails.org
[Ruby]: https://www.ruby-lang.org/en/
[use this guide to get set up on MacOS]: http://installfest.railsbridge.org/installfest/macintosh

### Getting Started

* After cloning this repo, run: `bin/setup`
* Read through the [CONTRIBUTING.md](CONTRIBUTING.md) file to learn how this
  team operates.

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


### Day-to-day

* Run the server(s): `foreman start`
* Visit [your local server](http://localhost:3000)
* To preview any emails that were sent while testing locally, visit
  the [running mailcatcher instance](http://localhost:1080/)
* Run tests and Rubocop: `rake`

### Deploying

* [CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits) is currently set up to
  deploy green builds to **staging**.
* Use heroku pipelines to promote from staging to **production**. If you want to promote
  from the Heroku web page or CLI, be sure to run migrations afterwards.

### Debugging

* Call `binding.pry` anywhere in the code to stop execution and get a debugger console.
* Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.
* To get a good look at and debug any emails that were sent from your running
  development environment visit your local [mailcatcher server](http://localhost:1080/).

### CircleCI green builds deploy to Heroku staging servers

1. Get your Heroku API Key for a user from (https://dashboard.heroku.com/account)
1. Paste API Key in the CircleCI account settings page (https://circleci.com/account/heroku)
1. Set your user as the deploy user CircleCI per project settings page (https://circleci.com/gh/codeforamerica/michigan-benefits/edit#heroku)
1. Ensure that your <github username>@circleci.com and generated ssh key show up on heroku (https://dashboard.heroku.com/account)
1. Click rebuild if necessary

## What's Included

### Step Skipping

This application is a long questionaire.
You will probably want to work on parts of it
without completing the whole application.

After booting the server and filling out the first step,
go to `http://localhost:3000/steps`
to jump around.

### Document / Photo Uploading Details

* The file uploading service is called [Shubox]. The [dashboard] can be
  accessed with account info found in 1password. Ping [@jayroh] for any
  questions or issues related to Shubox.
* The file limit is currently set to 3MB. That can be bumped up if we notice
  that people are often taking photos or attaching documents larger than that.
* The file formats currently allowed as "Documents" consist of:
  * .doc
  * .docx
  * .gif
  * .jpg
  * .pdf
  * .png

[Shubox]: https://shubox.io
[dashboard]: https://dashboard.shubox.io
[@jayroh]: https://github.com/jayroh

#### Document uploading on staging

NOTE: Document upload via [Shubox] on staging requires using this URL:

    http://staging.michiganbenefits.org

and will not work on this URL:

    https://michigan-benefits-staging.herokuapp.com

### Spec Helpers

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
