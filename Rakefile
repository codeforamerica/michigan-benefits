# frozen_string_literal: true

require_relative "config/application"

task(:rubocop) do
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
end

task default: %w(spec rubocop)

Rails.application.load_tasks
