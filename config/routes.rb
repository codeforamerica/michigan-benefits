Rails.application.routes.draw do
  devise_for :admin_users

  authenticate :admin_user do
    # match "/delayed_job" => DelayedJobWeb, anchor: false, via: %i(get post)

    namespace :admin do
      resources :snap_applications do
        get "pdf", on: :member
      end
      resources :medicaid_applications do
        get "pdf", on: :member
      end
      resources :common_applications do
        get "pdf", on: :member
      end
      resources :exports, only: %i[index show]
      resources :members, only: %i[index show]
      resources :employments, only: %i[index show]
      resources :driver_errors, only: %i[index show]
      resources :addresses, only: %i[index show]
      resources :household_members, only: %i[index show]

      root to: "snap_applications#index"
    end
  end

  resources :messages

  root "static_pages#index"
  get "/clio" => "static_pages#clio"
  get "/privacy" => "static_pages#privacy"
  get "/terms" => "static_pages#terms"
  get "/union" => "static_pages#union"

  resource :confirmations, only: %i[show]
  resources :documents, only: %i[index new create destroy]

  if Rails.env.test? || Rails.env.development?
    resource :file_preview, only: %i[show]
  end

  resources :numbers, module: :stats, only: %i[index]

  resource :resource, only: %i[show]
  resource :sessions, only: %i[new destroy] do
    collection do
      get :clear, to: "sessions#destroy"
    end
  end

  resource :skip_send_application, only: [:create]

  resources :steps, only: %i[index show] do
    collection do
      StepNavigation.steps_and_substeps.each do |controller_class|
        { get: :edit, put: :update }.each do |method, action|
          match "/#{controller_class.to_param}",
            action: action,
            controller: controller_class.controller_path,
            via: method
        end
      end

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

  unless Rails.env.production?
    resources :sections, controller: :forms, only: %i[index show] do
      collection do
        FormNavigation.all.each do |controller_class|
          { get: :edit, put: :update }.each do |method, action|
            match "/#{controller_class.to_param}",
              action: action,
              controller: controller_class.controller_path,
              via: method
          end
        end
      end
    end
  end
end
