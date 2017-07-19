# frozen_string_literal: true

namespace :steps do
  desc 'Prints all step names and refactor progress.'
  task print: :environment do
    steps = StepNavigation.steps
    refactored = []

    steps.each do |step|
      name = step.name
      if StepNavigation.refactored?(step)
        refactored << step
        puts "✅  #{name}"
      else
        puts name
      end
    end

    puts '-----'

    percent = ((refactored.length.to_f / steps.length) * 100).round

    puts "#{refactored.length}/#{steps.length} steps have been refactored (#{percent}%)"
  end

  desc 'Opens the given step both locally and on staging for comparison.'
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
      raise %(No step found with name "#{step_name}"!)
    end
  end

  desc 'Opens the last refactored step.'
  task open_last_refactored: :environment do
    open(
      StepNavigation.steps.reverse_each.detect do |step|
        StepNavigation.refactored?(step)
      end
    )
  end

  desc 'Opens the next step to be refactored.'
  task open_next_refactor: :environment do
    step = StepNavigation.steps.detect { |step| !StepNavigation.refactored?(step) }
    if step.present?
      open(steps[index])
    else
      puts 'No steps left to refactor!'
    end
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
