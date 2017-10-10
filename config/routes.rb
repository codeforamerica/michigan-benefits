# frozen_string_literal: true

Rails.application.routes.draw do
  match "/delayed_job" => DelayedJobWeb, anchor: false, via: %i(get post)

  namespace :admin do
    resources :snap_applications do
      post "resend_email", on: :member
      get "pdf", on: :member
    end
    resources :exports, only: %i[index show]
    resources :members
    resources :driver_errors, only: %i[index show]

    root to: "snap_applications#index"
  end

  root "static_pages#index"
  get "/clio" => "static_pages#clio"
  get "/privacy" => "static_pages#privacy"
  get "/terms" => "static_pages#terms"
  get "/union" => "static_pages#union"
  get "/dual-index" => "static_pages#dual_index"

  resource :confirmations, only: %i[show]
  resources :documents, only: %i[index new create destroy]

  if Rails.env.test? || Rails.env.development?
    resource :file_preview, only: %i[show]
  end

  resource :resource, only: %i[show]
  resource :sessions, only: %i[new destroy] do
    collection do
      get :clear, to: "sessions#destroy"
    end
  end

  resource :skip_send_application, only: [:create]

  # Medicaid
  resources :steps, only: %i[index] do
    collection do
      Medicaid::StepNavigation.steps_and_substeps.each do |controller_class|
        { get: :edit, put: :update }.each do |method, action|
          match "/#{controller_class.to_param}",
            action: action,
            controller: controller_class.controller_path,
            via: method
        end
      end
    end
  end

  # FAP
  resources :steps, only: %i[show index] do
    collection do
      StepNavigation.steps_and_substeps.each do |controller_class|
        { get: :edit, put: :update }.each do |method, action|
          match "/#{controller_class.to_param}",
            action: action,
            controller: controller_class.controller_path,
            via: method
        end
      end
    end
  end

  get "/styleguide", to: "styleguides#index"
end
