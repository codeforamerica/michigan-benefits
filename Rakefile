require_relative "config/application"

namespace :lint do
  task :autocorrect do
    require "rubocop/rake_task"
    RuboCop::RakeTask.new
    Rake::Task["rubocop:auto_correct"].execute
  end
end

task :brakeman do
  sh "brakeman"
end

Rails.application.load_tasks

task default: %w(lint:autocorrect bundler:audit brakeman spec)

task "db:schema:dump": "strong_migrations:alphabetize_columns"
