require_relative "config/application"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task(:brakeman) do
  sh "brakeman"
end

task default: %w(rubocop:auto_correct bundler:audit brakeman spec)

Rails.application.load_tasks

task "db:schema:dump": "strong_migrations:alphabetize_columns"
