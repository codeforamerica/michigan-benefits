# Contributing

This document outlines how this team ships features, bug fixes, and everything
in between.

## Workflow

The most common workflow is:

* A change is initiated and discussed via a
  [Trello](https://trello.com/b/aBqTrqaJ/michiganbridgesorg) card.
* All new Trello cards are added to the "Inbox" Trello list.
* During a weekly planning meeting, prioritized Trello cards are added to the
  "This week" Trello list. Cards in this list should have enough detail to be
  actionable. Top priority items are at the top of the list.
* When someone starts working on a task, they move the Trello card into "In
  Progress" and assign themselves so that others know they are working on it.
* All code is written on a branch *other* than `master`. The team is not picky
  about branch naming.
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
* By default, it is expected that the PR author will merge when ready. In some
  cases, a reviewer may merge if merging is time-sensitive or the author is
  unavailable to merge for some reason.
* Whoever merges a branch into `master` deletes the branch after merging.
* Merged code is automatically deployed to the [staging
  environment](https://michigan-benefits-staging.herokuapp.com/) after a green
build on Circle CI.

## Workflow caveats

* When two people are pairing on something, code can be merged to `master`
  without an explicit PR / code review process.
* During the team's weekly retro meetings, feedback about the workflow is noted
  and related changes are incorporated into this document.
