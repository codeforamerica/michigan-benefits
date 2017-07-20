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

  resources :steps, only: %i[show index] do
    StepNavigation.steps_and_substeps.each do |controller_class|
      path = "/#{controller_class.to_param}"
      controller_path = controller_class.controller_path
      get path, action: :edit, controller: controller_path, on: :collection
      put path, action: :update, controller: controller_path, on: :collection
    end
  end

  get '/form', to: 'forms#show'
  get '/styleguide', to: 'styleguides#index'
end
