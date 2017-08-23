# Michigan Benefits

[![CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits.svg?style=svg)](https://circleci.com/gh/codeforamerica/michigan-benefits)
[![Code Climate](https://codeclimate.com/github/codeforamerica/michigan-benefits/badges/gpa.svg)](https://codeclimate.com/github/codeforamerica/michigan-benefits)
[![Test Coverage](https://codeclimate.com/github/codeforamerica/michigan-benefits/badges/coverage.svg)](https://codeclimate.com/github/codeforamerica/michigan-benefits/coverage)

* [GitHub](https://github.com/codeforamerica/michigan-benefits)
* [Trello](https://trello.com/b/aBqTrqaJ/the-digital-assister)
* [Trello - product](://trello.com/b/aBqTrqaJ/the-digital-assister)
* [InVision](https://projects.invisionapp.com/d/main#/projects/prototypes/10425326)
* [CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits)
* [Staging](https://michigan-benefits-staging.herokuapp.com)
* [Production](https://michigan-benefits-production.herokuapp.com)
* [Prototype demo](https://michigan-benefits-prod.herokuapp.com/)

## Driving Against MI Bridges

The only requirements to run the driver code are:

1. A sufficiently complete `SnapApplication`
2. Chrome and Chromedriver are installed (the latest versions). `./bin/setup`
   should get this set up for you automatically.

To run the driver code you could drop into a rails console and (where
`<id>` is the id of a snap application record) run:

```ruby
snap_application = SnapApplication.find(<id>)
MiBridges::Driver.new(snap_application: snap_application).run
```

There are three extra environment variables you can set to modify the behavior
of the script.

1. If you would like it to run in a FULL chrome browser instead of the headless
   version, set `WEB_DRIVER` to `chrome`.
2. If you'd like it to run a little slower, perhaps for demo purposes or to
   look more "human", you may set `DRIVER_SPEED` to `slow` or `medium`.
3. If you would like to display a log of some of the things happening as it
   "drives" set `DEBUG_DRIVE` to `true`

Example:

```sh
DRIVER_SPEED=slow \
  WEB_DRIVER=chrome \
  DEBUG_DRIVE=true \
  ./bin/rails runner "MiBridges::Driver.new(snap_application: SnapApplication.find(ID)).run"
```

## Deploying

### Requirements

* pdftk - see [https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack](https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack)

## Developing

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
