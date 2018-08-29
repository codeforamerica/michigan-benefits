# Contributing

This document outlines how to get the application set up
and how we continuously ship working software.

## External Contributions

This document outlines the process for members of the Code for
America development team and other partners.

While this project is open source,
we are not currently seeking external contributions.
If you would like to learn more about this project,
please email <hello@michiganbenefits.org>.

## Getting Set Up

### macOS

Install [Homebrew].

Install [Heroku CLI].

`brew install heroku/brew/heroku`

Install and start PostgreSQL.

`brew install postgresql`

`brew services start postgresql`

[Homebrew]: https://brew.sh/
[Heroku CLI]: https://devcenter.heroku.com/articles/heroku-cli

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

## Day-to-day Development

### Local Server

* Run the server(s): `foreman start`
* Visit [your local server](http://localhost:3000)
* To preview any emails that were sent while testing locally, visit the [running mailhog instance](http://localhost:8025/)
* Run tests, Rubocop, bundle audit, and Brakeman: `rake`

### Conventions

* **Secrets** - api keys and secrets should be placed in `config/secrets.yml` and
  referenced via Rails' secrets api. Eg: `Rails.application.secrets.an_api_key`.
* **Environment variables** - required environment variables for development should be included in the `.env` file.

    When adding a new required environment variable, update `.env.sample`. When preparing a development environment for the first time, copy `.sample.env` as `.env` and replace any required values.


### Step Navigation

This application is a long questionnaire. You will probably want to work on parts of 
it without completing the whole application.

After booting the server and filling out the first few questions,
go to `http://localhost:3000/sections` to jump around.

If [running the application in single-program application mode](#single-program-mode) 
navigation can instead be found at `http://localhost:3000/steps` after completing 
the first few questions.


### Single-program mode

A previous iteration of MichiganBenefits.org featured single-program applications 
for SNAP and Medicaid, instead of one integrated application.

It's still possible to run the application in single-program mode. To do set, set `SINGLE_PROGRAM_APPLICATIONS_ENABLED=true` in the environment before 
starting the server (e.g. `SINGLE_PROGRAM_APPLICATIONS_ENABLED=true foreman start`).

### Testing

#### Running specs

For development purposes, we generally just run `rspec`.

By default, running `rspec` excludes:

* Accessibility checks (enabled with `RUN_ACCESSIBILITY_SPECS=true`)

Because of the length of time it takes to run accessibility checks, we only run them on CI.

Feature tests for single-program mode applications can be disabled by excluding specs
with the `single_app_flow` tag (e.g. `rspec --tag ~single_app_flow`). Since this 
codepath is no longer in active development, it's recommended to add the tag exclusion 
to your local `.rspec` config.

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

### Rebuilding the Docker image for CI

To run tests and other checks on Circle CI, we use a custom Docker image hosted on [Docker Hub](https://hub.docker.com/r/chartsockcfa/michigan-benefits-ci/).

To update this image (for example, when we update our version of ruby in the app):

* cd into `.ci`
* Make any required updates to the Dockerfile (updating base image, adding dependencies, etc.)
* With [Docker for Mac](https://www.docker.com/docker-mac) running, type `docker build` in Terminal to build the image
* Push the image with a unique tag to Docker Hub (with tag) via instructions [here](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html)
* Update the image tag in our Circle CI config at `.circleci/config.yml`


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

Require any users to enable two-factor authentication on account setup.

[administrate]: https://github.com/thoughtbot/administrate


### Styleguide/Branding
This application was designed using an Atomic design system.

The styleguide is a modified version of the [GetCalFresh Styleguide](http://demo.getcalfresh.org/styleguide).

A Rails gem version of the base styles can be found at [https://github.com/codeforamerica/cfa-styleguide-gem](the CfA Styleguide Gem repository).


### Deploying

See [DEPLOYING.md](DEPLOYING.md)
