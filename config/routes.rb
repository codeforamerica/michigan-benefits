# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#new'

  resource :confirmations, only: %i[show]
  resources :documents, only: %i[index new create destroy]
  resource :file_preview, only: %i[show] if Rails.env.test? || Rails.env.development?
  resource :resource, only: %i[show]
  resource :sessions, only: %i[new destroy] do
    collection do
      get :clear, to: 'sessions#destroy'
    end
  end
  resources :users, only: %i[new create]

  resources :steps, only: :index

  scope :steps do
    steps_and_substeps = StepNavigation.steps_and_substeps
    steps_and_substeps_by_param = steps_and_substeps.index_by(&:to_param)
    actions_by_request_method = {
      'GET' => :edit,
      'PUT' => :update
    }

    # This allows /steps/introduction-introduce-yourself to correctly route to
    # IntroductionIntroduceYourselfController. Without this, routing to StepsController
    # takes precedence over routing to its children.
    match ':__step_name__', to: lambda { |env|
      controller_class = steps_and_substeps_by_param[
        env['action_dispatch.request.path_parameters'].delete(:__step_name__)
      ]

      action = actions_by_request_method[env['REQUEST_METHOD']] if controller_class

      if action
        controller_class.action(action).call(env)
      else
        [404, { 'X-Cascade' => 'pass' }, []]
      end
    }, as: :step, via: :all

    # Generates path helpers and routes for all named steps.
    steps_and_substeps.each do |controller_class|
      path = "/#{controller_class.to_param}"
      get path, action: :edit, controller: controller_class.controller_path
      put path, action: :update, controller: controller_class.controller_path
    end
  end

  get '/form', to: 'forms#show'
  get '/styleguide', to: 'styleguides#index'

  # SSL/Let's Encrypt
  get '/.well-known/acme-challenge/:id' => 'acme_challenges#show'
end
