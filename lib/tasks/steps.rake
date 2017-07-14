# frozen_string_literal: true

namespace :steps do
  def open(step)
    local = 'http://localhost:3000'
    staging = 'https://michigan-benefits-staging.herokuapp.com'

    [local, staging].each do |host|
      url = Rails.application.routes.url_helpers.step_url(step, host: host)
      system("open #{url}")
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
        step < SimpleStepController
      end
    )
  end
end
