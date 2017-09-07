### Timing for Deploys

* Staging: Deployed on successful builds from Master.
* Production: Deployed after acceptance at standup.

### Pre-Production Checklist
- [ ] Review the buildpacks on staging and production. Are they the same? If
  not, make them the same.
- [ ] Skim the diff between the current production sha and master
  - `git fetch --all && git diff production/master staging/master`
  - [ ] Any new ENV variables? If so, set them.
  - [ ] What about rake tasks? If so, make note of them to run after deploy.
  - [ ] Any scary looking migrations that could result in data loss or prevent
    roll back? If so, perhaps we should hold off on the deploy until we fix the
    scary migrations

### Actually Deploying Production
- [ ] `heroku pipelines:promote -a michigan-benefits-staging`
- [ ] Run post-deploy rake tasks
