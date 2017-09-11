# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :snap_applications do
      post "resend_fax", on: :member
      get "pdf", on: :member
    end

    root to: "snap_applications#index"
  end

  root "pages#index"
  get "/clio" => "pages#clio"
  get "/privacy" => "pages#privacy"
  get "/terms" => "pages#terms"
  get "/union" => "pages#union"

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
