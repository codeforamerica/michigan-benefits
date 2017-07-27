# Michigan Benefits

* [GitHub](https://github.com/codeforamerica/michigan-benefits)
* [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1982139)
* [InVision](https://projects.invisionapp.com/d/main#/projects/prototypes/10425326)
* [CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits)
* [Staging](https://michigan-benefits-staging.herokuapp.com)
* [Production](https://michigan-benefits-prod.herokuapp.com)

## Deploying

### Requirements

* pdftk - see [https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack](https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack)

## Developing

This project is built on top of [Citizen Rails](https://github.com/citizencode/citizen-rails).

**See [README-citizen-rails-template.md](README-citizen-rails-template.md) for instructions on
using the Citizen Rails template project as a base for your own project.**

### Getting Started

* After cloning this repo, run: `bin/setup`
* Run `bundle exec citizen doctor` repeatedly until all the failures are fixed.
* Read through the [CONTRIBUTING.md](CONTRIBUTING.md) file to learn how this
  team operates.

### citizen-scripts

The Gemfile includes `citizen-scripts` which is a collection of useful dev utils. It includes a command
called `citizen`. Running `citizen` with no arguments will show usage information. Depending on your
Ruby setup, you might need to run `bundle exec citizen` instead of just `citizen`.

### Day-to-day

* Run the server: `heroku local` and [http://localhost:3000](http://localhost:3000)
* Run tests: `bundle exec citizen test`
* Pull, run tests, push: `bundle exec citizen pushit`

### Deploying

* [CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits) is currently set up to
  deploy green builds to **staging**.
* Use `citizen promote` to promote from staging to **production**. If you want to promote
  from the Heroku web page or CLI, be sure to run migrations afterwards.

### Debugging

* Call `binding.pry` anywhere in the code to stop execution and get a debugger console.
* Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.

### CircleCI green builds deploy to Heroku staging servers

1. Get your Heroku API Key for a user from (https://dashboard.heroku.com/account)
1. Paste API Key in the CircleCI account settings page (https://circleci.com/account/heroku)
1. Set your user as the deploy user CircleCI per project settings page (https://circleci.com/gh/citizencode/skoshi/edit#heroku)
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
