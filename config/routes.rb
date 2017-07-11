Rails.application.routes.draw do
  root "users#new"

  resource :confirmations, only: %i[show]
  resources :documents, only: %i[index new create destroy]
  resource :file_preview, only: %i[show] if Rails.env.test? || Rails.env.development?
  resource :resource, only: %i[show]
  resource :sessions, only: %i[new destroy] do
    collection do
      get :clear, to: "sessions#destroy"
    end
  end
  resources :users, only: %i[new create]

  scope :steps do
    StepNavigation::SIMPLE_STEPS.each do |klass|
      path = "/#{klass.to_param}"
      name = klass.name.underscore

      get path, to: "#{name}#edit"
      put path, to: "#{name}#update"
    end
  end

  resources :steps, only: %i[index show update]

  get "/form", to: "forms#show"
  get "/styleguide", to: "styleguides#index"

  # SSL/Let's Encrypt
  get '/.well-known/acme-challenge/:id' => 'acme_challenges#show'
end
