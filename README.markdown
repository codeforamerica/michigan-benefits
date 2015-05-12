Citizen Rails Template
====
This project is for jumpstarting Client and Citizen projects under the included MIT license. Feel free to license the client project or your own project as you see fit.

There is not intent to make this a public project. But consider it sour dough for for friends, family, and clients.

One way to do this:

    mkdir your-new-project
    cd your-new-project
    git init
    git remote add citizen-rails git@github.com:citizencode/citizen-rails
    git fetch citizen-rails
    git reset --hard citizen-rails/master

Customize this project for your app
===================================

1. Search all files in the project for "citizen" and "Citizen" and change the name to match the project you're starting, including the database names in `config/database.yml`.
1. The site can be password-protected while in alpha. Edit `config/application.rb` and customize `config.site_username` and `config.site_password` for the site, and enable password-protection by setting `config.require_site_login = true`.
1. You can create a whitelist of emails which will automatically become admins when they sign up. Add these emails to `config/automatically_admins.yml`.
1. Remove the `LICENSE` file from the root directory.
1. Delete this section. You only need to do these steps once.

Local development setup (without Docker)
=========================================

1. Install [Postgres.app](http://postgresapp.com).
1. Install this project's gems by running:

               bundle

   a. If the "pg" gem fails to install on OS X, try running `env ARCHFLAGS="-arch x86_64" bundle` instead. Or better yet, switch to Docker (see below)

1. Initialize the app's database:

               rake db:setup

1. Install foreman:

    gem install foreman

1. Launch the server with `foreman start` and see it running at http://localhost:3000

1. To run tests, see Tools section below.

Local development setup (with Docker & Fig)
======================================

1. Install docker http://docs.docker.com/installation/mac/
  a. By default boot2docker will create a VM that uses 2GB of memory.  If this is too much for your machine, use

    boot2docker init -m 512

1. Install fig http://www.fig.sh/install.html
1. Configure
    map `boot2docker ip` to localdocker in /etc/hosts
1. Build image

    fig build

1. Create database

    fig run web db:setup db:test:prepare

1. Run db and web servers

    fig up

1. Develop code on your local machine.  It will be updated in the image.
  a. Open localdocker:3000 to see changes
  a. If you change the Dockerfile or the Gemfile, stop fig, then re-run
     `fig build` and `fig up`.
1. To run tests, see Tools section below.  Prefix all commands with
   `fig run web`

To shutdown fig, Ctrl-C it. To shutdown Docker `boot2docker down`.

Heroku setup
============

1. Create the Heroku app:

		heroku apps:create my-app-name

   Or if it's already created, add the git remote to your local repository like this:

		git remote add heroku git@heroku.com:my-app-name.git

1. Set the host name to use when generating URLs in e-mails:

		heroku config:set ACTION_MAILER_HOST='your-app.herokuapp.com'

1. Turn on Postmark for SMTP mail:

		heroku addons:add postmark

1. Run this command and click on "Sender Signatures" at the top of the web page that opens:

		heroku addons:open postmark

1. Confirm an e-mail address to use for sending. Also set up DKIM for that sender if you are brave. (It involves editing DNS records for the sender's e-mail domain.)

1. Test e-mail by sending an e-mail to the address you configured in the last steps:

		heroku run console

		m = "registred_email_from_last_step"; ActionMailer::Base.mail(from:m, to:m, subject: Time.now.to_s, body: rand.to_s).deliver

1. Eventually, remove everyone from `config/automatically_admins.yml`. After a few admins exist, you should use the admin tools to grant new accounts admin permissions.

1. Exception notification is done through Airbrake:
    1. As an admin with payment configured, setup Airbrake on Heroku. This will add the heroku environment variable:

            heroku addons:add airbrake

  	1. All exceptions are sent by email:
    	* By default to the email group associated with the heroku account that owns the project. **For example**: `accounts+heroku@citizencode.io`
    	* This should be changed to the Citizen Code error account with a email alias for filtering by project: `errorhound+PROJECT_NAME@citizencode.io`
    	* You might have to accept a mailchimp "Newsletter Subscription" (!!?!?!) to receive airbrake notifications.

  	1. To view exceptions on the web, visit:
    	* https://addons-sso.heroku.com/apps/YOUR_APP_NAME/addons/airbrake
           Example: [citizen-rails-template airbrake](https://addons-sso.heroku.com/apps/citizen-rails-template/addons/airbrake)
  	1. To create a fake error for testing the system:

            heroku run rake airbrake:test

    1. To set up client-side Javascript error reporting, set the environment variable `AIRBRAKE_PROJECT_ID`
       to the project ID, which can be foundin the URL of the Airbrake admin console for your app.

    1. To differentiate between staging and production, `AIRBRAKE_ENV` can be set to 'staging' on the staging site.

1. Set up daily backups of a
   production Heroku database:

        heroku pg:backups schedule DATABASE_URL --at '03:00 PST' -a <app name>

Tools
=====

Development
-----------

Run tests

    bin/spec

Run more thorough tests (with `render_views` turned on, as coverage for templates)

    bin/spect

Run thorough tests and deploy

    bin/shipit

Production
----------

[Rollback](https://devcenter.heroku.com/articles/heroku-postgres-rollback) a
production Heroku database to a prior state.  Hobby dbs do not have rollback,
Standard dbs can be rolled back to any time in the last day (in increments of 1
minute), and Premium dbs any time in the last week.

If you have [daily backups set
up](https://devcenter.heroku.com/articles/pgbackups) you can restore them.

References
==========

* [Configuring Rails for Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
* [Setting up Postgres on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
