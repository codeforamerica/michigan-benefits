Customize this project for your app
===================================

1. Search all files in the project for "citizen" and change the name to match the project you're starting, including the database names in `config/database.yml`.
1. The site is password-protected by default. Edit `config/application.rb` and customize `config.site_username` and `config.site_password` for the site, or disable password-protection by setting `config.require_site_login = false`.
1. Delete this section. You only need to do these steps once.

Local development setup
=======================

1. Install [Postgres.app](http://postgresapp.com).
1. Install this project's gems by running:

		bundle

	If the "pg" gem fails to install on OS X, try running `env ARCHFLAGS="-arch x86_64" bundle` instead.

1. Initialize the app's database:

		rake db:create db:migrate


Heroku setup
============

1. Create the Heroku app:

		heroku apps:create my-app-name

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


Tools
=====

Get code coverage with

    rake simplecov

(This doesn't seem to work since the transition to rspec.)


References
==========

* [Configuring Rails for Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
* [Setting up Postgres on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
