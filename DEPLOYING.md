## Deploying

### Requirements

* pdftk - see [https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack](https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack)

### Timing for Deploys

* Staging: Deployed automatically on successful builds from `master`.
* Pre-production: Deployed automatically on successful builds from `production`.
* Production: Deployed after acceptance is empty. After standup is a great time to do this.

### Deploying to Staging

[CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits) is currently set up to deploy green builds to **staging**.

You can repeat the setup steps this way:

1. Get a Heroku API Key for a user from (https://dashboard.heroku.com/account)
1. Paste API Key in the CircleCI account settings page (https://circleci.com/account/heroku)
1. Set a user as the deploy user CircleCI per project settings page (https://circleci.com/gh/codeforamerica/michigan-benefits/edit#heroku)
1. Ensure the <github username>@circleci.com and generated ssh key show up on heroku (https://dashboard.heroku.com/account)
1. Click rebuild if necessary


### Deploying to Production

Our release process will promote the pre-production environment to production and demo.

Before deploying to production, we want to make sure that:

* All tickets that are awaiting acceptance have been accepted
* All necessary configuration variables are set on production
* All buildpacks are the same between staging and production

To do this, run `bin/release` and it will walk through each of those steps.

As this process changes, please keep the script up to date.
