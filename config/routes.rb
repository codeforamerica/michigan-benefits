Rails.application.routes.draw do
  root "landing#show"

  resource :file_preview, only: %i[show] if Rails.env.test? || Rails.env.development?

  resource :sessions, only: %i[new create destroy]
  resources :users, only: %i[new create]

  # SSL/Let's Encrypt
  get '/.well-known/acme-challenge/:id' => 'acme_challenges#show'
end
