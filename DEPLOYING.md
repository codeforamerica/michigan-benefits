### Timing for Deploys

* Staging: Deployed automatically on successful builds from Master.
* Production: Deployed after acceptance at standup.

### Deploying to Production
Before production, we want to make sure that:
* All tickets that are awaiting acceptance have been accepted
* We've done a quick code review just to make sure things seem legit
* All configuration variables are set on prod that are necessary
* All buildpacks are the same between staging and production

To do this, run `bin/release` and it will walk through each of those steps,
prompting you to say it's all good.

