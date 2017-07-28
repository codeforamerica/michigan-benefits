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

## Deploying

### Requirements

* pdftk - see [https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack](https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack)

## Developing

### Getting Started

* After cloning this repo, run: `bin/setup`
* Read through the [CONTRIBUTING.md](CONTRIBUTING.md) file to learn how this
  team operates.

### Day-to-day

* Run the server: `heroku local` and [http://localhost:3000](http://localhost:3000)
* Run tests and Rubocop: `rake`

### Deploying

* [CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits) is currently set up to
  deploy green builds to **staging**.
* Use heroku pipelines to promote from staging to **production**. If you want to promote
  from the Heroku web page or CLI, be sure to run migrations afterwards.

### Debugging

* Call `binding.pry` anywhere in the code to stop execution and get a debugger console.
* Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.

### CircleCI green builds deploy to Heroku staging servers

1. Get your Heroku API Key for a user from (https://dashboard.heroku.com/account)
1. Paste API Key in the CircleCI account settings page (https://circleci.com/account/heroku)
1. Set your user as the deploy user CircleCI per project settings page (https://circleci.com/gh/codeforamerica/michigan-benefits/edit#heroku)
1. Ensure that your <github username>@circleci.com and generated ssh key show up on heroku (https://dashboard.heroku.com/account)
1. Click rebuild if necessary

## What's Included

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
