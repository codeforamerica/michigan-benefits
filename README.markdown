App SETUP
=====

1. Search the project for 'citizen' and change the name to match the project you're starting.
1. In `config/database.yml`, change "citizen_rails_development" and "citizen_rails_test" to match the name of the application.
2. 1. Edit `config.beta_username` and `config.beta_password` in `config/application.rb`, optionally disabling the beta HTTP authentication by setting `config.require_beta_login` to `false`.
1. Install Postgres.app
2. 
		
		bundle
	if bundle fails to install the 'pg' gem, then use `env ARCHFLAGS="-arch x86_64" bundle`
1. 
		
		rake db:create db:migrate
		
Heroku SETUP
=====
1. create the heroku app:

		heroku apps:create my-app-name 		

1. Turn on postmark for smtp mail: 
		
		heroku addons:add postmark

1. Click on sender signature at the top of the page opened by:

		heroku addons:open postmark

1. confirm the email; setup DKIM if you are brave.

1.
		heroku config:set ACTION_MAILER_HOST='your-app.herokuapp.com'

1. Test it with

		heroku run console
		
		m = "registred_email_from_last_step"; ActionMailer::Base.mail(from:m, to:m, subject: Time.now.to_s, body: rand.to_s).deliver

TOOLS
=====

Get code coverage with

    rake simplecov


REFERENCES
==========

* [Configuring Rails for Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
* [Setting up Postgres on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
