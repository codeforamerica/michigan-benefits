Citizen Rails Template
====
This project is for jumpstarting Client and Citizen projects under the included MIT license. Feel free to license the client project or your own project as you see fit.

There is not intent to make this a public project. But consider it sour dough for for friends, family, and clients.

Customize this project for your app
===================================

1. Search all files in the project for "citizen" and "Citizen" and change the name to match the project you're starting, including the database names in `config/database.yml`.
1. The site is password-protected by default. Edit `config/application.rb` and customize `config.site_username` and `config.site_password` for the site, or disable password-protection by setting `config.require_site_login = false`.
1. You can create a whitelist of emails which will automatically become admins when they sign up. Add these emails to `config/automatically_admins.yml`.
1. Remove the `LICENSE` file from the root directory.
1. Delete this section. You only need to do these steps once.

Local development setup (without Vagrant)
=========================================

1. Install [Postgres.app](http://postgresapp.com).
1. Install this project's gems by running:

		bundle

	If the "pg" gem fails to install on OS X, try running `env ARCHFLAGS="-arch x86_64" bundle` instead.

1. Initialize the app's database:

		rake db:create db:migrate

Local development setup (with Docker & Fig)
======================================
1. Install docker http://docs.docker.com/installation/mac/
2. Install fig http://www.fig.sh/install.html
3. Configure
		map `boot2docker ip` to localdocker in /etc/hosts
4. Build & Run
		fig build
		fig up
5. Open localdocker:3000
6. Test `fig run web bundle exec rake spec`

Local development setup (with Vagrant)
======================================

1. Download Vagrant: http://www.vagrantup.com/downloads.html
1. Start Vagrant by running:

		vagrant up

   This can take around 10 minutes when the first time.

**Notes:**

* To ssh to the Vagrant box, run `vagrant ssh`.
* The Vagrant machine's IP address is 10.0.50.50.
* Vagrant is configured to forward port 5000 on the host machine (your Mac) to port 5000 on the guest machine (Vagrant)
* The Vagrant box is configured with the `/vagrant.sh` and `/vagrant_privileged.sh` scripts in this repo.

**Limitations:**

* You currently cannot connect directly to the database running in Vagrant.

Vagrant + RubyMine
------------------

1. Install RubyMine 7 (the EAP version).
1. Go to Settings > Languages and Frameworks > Ruby SDK and Gems.
1. Click the "+" button and add a new remote SDK.
1. Choose "Vagrant".
1. Use `/home/vagrant/.rbenv/versions/2.1.2/bin/ruby` for the Ruby interpreter path.

You should be able to run tests as you normally do, plus you can run the server from the run configurations.


Running the server locally
==========================

1. Install foreman:

		gem install foreman

1. Launch the server:

		foreman start

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

Tools
=====

Get code coverage with

    rake simplecov

(This doesn't seem to work since the transition to rspec.)

[Rollback](https://devcenter.heroku.com/articles/heroku-postgres-rollback) a
production Heroku database to a prior state.  Hobby dbs do not have rollback,
Standard dbs can be rolled back to any time in the last day (in increments of 1
minute), and Premium dbs any time in the last week.

Set up [daily backups](https://devcenter.heroku.com/articles/pgbackups) of a
production Heroku database.

References
==========

* [Configuring Rails for Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
* [Setting up Postgres on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
