# frozen_string_literal: true

namespace :steps do
  task all: :environment do
    StepNavigation.steps.each do |step|
      name = step.name
      puts StepNavigation.refactored?(step) ? "#{name} (refactored)" : name
    end
  end

  task :open, [:step_name] => [:environment] do |_, args|
    step_name = args.step_name

    suffix = 'Controller'

    classified_name = step_name.underscore.classify

    controller_name =
      if classified_name.ends_with?(suffix)
        classified_name
      else
        "#{classified_name}#{suffix}"
      end

    constant_name = [controller_name, classified_name].detect do |s|
      Kernel.const_defined?(s)
    end

    if constant_name.present?
      open(constant_name.constantize)
    else
      STDERR.puts(%(No step found with name "#{step_name}"!))
    end
  end

  task open_last_refactored: :environment do
    open(
      StepNavigation.steps.reverse_each.detect do |step|
        StepNavigation.refactored?(step)
      end
    )
  end

  task open_next_refactor: :environment do
    steps = StepNavigation.steps
    index = steps.rindex { |step| StepNavigation.refactored?(step) }
    open(steps[index + 1])
  end

  def open(step)
    local = 'http://localhost:3000'
    staging = 'https://michigan-benefits-staging.herokuapp.com'

    [local, staging].each do |host|
      url = Rails.application.routes.url_helpers.step_url(step, host: host)
      system("open #{url}")
    end
  end
end
