Customize this project for your app
===================================

1. Search all files in the project for "citizen" and change the name to match the project you're starting, including the database names in `config/database.yml`.
1. The site is password-protected by default. Edit `config/application.rb` and customize `config.site_username` and `config.site_password` for the site, or disable password-protection by setting `config.require_site_login = false`.
1. Delete this section. You only need to do these steps once.

Local development setup (without Vagrant)
=========================================

1. Install [Postgres.app](http://postgresapp.com).
1. Install this project's gems by running:

		bundle

	If the "pg" gem fails to install on OS X, try running `env ARCHFLAGS="-arch x86_64" bundle` instead.

1. Initialize the app's database:

		rake db:create db:migrate


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


Tools
=====

Get code coverage with

    rake simplecov

(This doesn't seem to work since the transition to rspec.)


References
==========

* [Configuring Rails for Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
* [Setting up Postgres on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
