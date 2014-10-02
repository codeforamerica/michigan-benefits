SETUP
=====

1. Search the project for 'citizen' and change the name to match the project you're starting.
2. In `config/database.yml`, change "citizen_rails_development" and "citizen_rails_test" to match the name of the application.
3. Install Postgres.app and run `rake db:create db:migrate`.
4. Edit `config.beta_username` and `config.beta_password` in `config/application.rb`, optionally disabling the beta HTTP authentication by setting `config.require_beta_login` to `false`.

Troubleshooting
---------------

* If bundle fails to install the 'pg' gem, then use `env ARCHFLAGS="-arch x86_64" bundle`


TOOLS
=====

Get code coverage with

    rake simplecov


REFERENCES
==========

* [Configuring Rails for Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
* [Setting up Postgres on Heroku](https://devcenter.heroku.com/articles/heroku-postgresql)
