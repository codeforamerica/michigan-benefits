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
    get '/introduction-introduce-yourself',
      to: 'introduction_introduce_yourself#edit'

    post '/introduction-introduce-yourself',
      to: 'introduction_introduce_yourself#update'
  end

  resources :steps, only: %i[index show update]

  get "/form", to: "forms#show"
  get "/styleguide", to: "styleguides#index"

  # SSL/Let's Encrypt
  get '/.well-known/acme-challenge/:id' => 'acme_challenges#show'
end
