require_relative "config/application"

task(:rubocop) do
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
end

task(:brakeman) do
  sh "brakeman"
end

task default: %w(rubocop bundler:audit brakeman spec)

Rails.application.load_tasks

task "db:schema:dump": "strong_migrations:alphabetize_columns"
