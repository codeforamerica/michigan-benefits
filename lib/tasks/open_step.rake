# frozen_string_literal: true

task :open_step, [:step_name] => [:environment] do |_, args|
  step_name = args.step_name

  suffix = 'Controller'

  classified_name = step_name.underscore.classify

  controller_name =
    if classified_name.ends_with?(suffix)
      classified_name
    else
      "#{classified_name}#{suffix}"
    end

  step =
    if Kernel.const_defined?(controller_name)
      controller_name
    else
      classified_name
    end.constantize

  local = 'http://localhost:3000'
  staging = 'https://michigan-benefits-staging.herokuapp.com'

  [local, staging].each do |host|
    url = Rails.application.routes.url_helpers.step_url(step, host: host)
    system("open #{url}")
  end
end
