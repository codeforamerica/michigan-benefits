## Deploying

### Requirements

* pdftk - see [https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack](https://elements.heroku.com/buildpacks/fxtentacle/heroku-pdftk-buildpack)

### Timing for Deploys

* Staging: Deployed automatically on successful builds from `master`.
* Production: Manually deployed by running `bin/release` after acceptance is cleared. After standup is a great time to do this.

### Deploying to Staging

[CircleCI](https://circleci.com/gh/codeforamerica/michigan-benefits) is currently set up to deploy green builds to **staging**.

### Deploying to Production

Our release process will promote the staging environment to production and demo.

Before deploying to production, we want to make sure that:

* All tickets that are awaiting acceptance have been accepted
* All necessary configuration variables are set on production
* All buildpacks are the same between staging and production

To do this, run `bin/release` and it will walk through each of those steps.

As this process changes, please keep the script up to date.
