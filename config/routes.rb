Rails.application.routes.draw do
  root "users#new"

  resource :file_preview, only: %i[show] if Rails.env.test? || Rails.env.development?

  resource :sessions, only: %i[new create destroy]
  resources :steps, only: %i[show update]
  resources :users, only: %i[new create]

  get "/styleguide", to: "styleguides#index"

  # SSL/Let's Encrypt
  get '/.well-known/acme-challenge/:id' => 'acme_challenges#show'
end
