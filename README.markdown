Setup
=====

1. Search the project for 'citizen' and change the name to match the project you're starting.
2. In `config/database.yml`, change "citizen_rails_development" and "citizen_rails_test" to match the name of the application.
3. Install Postgres.app and run `rake db:create db:migrate`.

Troubleshooting
---------------

* If bundle fails to install the 'pg' gem, then use `env ARCHFLAGS="-arch x86_64" bundle`


TOOLS
=====

Get code coverage with

    rake simplecov
