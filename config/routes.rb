Rails.application.routes.draw do
  root "users#new"

  resource :file_preview, only: %i[show] if Rails.env.test? || Rails.env.development?

  resource :confirmations, only: %i[show]
  resource :sessions, only: %i[new destroy] do
    collection do
      get :clear, to: "sessions#destroy"
    end
  end
  resources :steps, only: %i[show update]
  resources :users, only: %i[new create]

  get "/form", to: "forms#show"
  get "/styleguide", to: "styleguides#index"

  # SSL/Let's Encrypt
  get '/.well-known/acme-challenge/:id' => 'acme_challenges#show'
end
