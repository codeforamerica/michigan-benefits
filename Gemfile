source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# Define views with Ruby
gem 'fortitude'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Fix $(function) and $(document).ready(function) when turoblinks are enabled
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc
# reduce controller duplication
gem 'responders'

# Use ActiveModel has_secure_password
# gem 'bcrypt'

# Use puma as the app server
gem 'puma'

# gem 'debugger', group: [:development, :test]

# heroku support (static asset serving, logging)
gem 'rails_12factor', group: :production

# authentication
gem 'sorcery'
gem 'pundit'

# e-mail
gem 'postmark-rails'
gem "letter_opener", group: :development # in dev, open emails in a browser
gem 'premailer-rails'
gem 'nokogiri' # required by premailer

# exception notification
gem 'airbrake'

# testing
group(:development, :test) do
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'faker'
end

group(:development) do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "spring-commands-rspec"
end

# Zurb Foundation
gem 'compass-rails'
gem 'foundation-rails'
gem 'foundation-icons-sass-rails'

# heroku recommends specifying a ruby version
ruby "2.2.2"
