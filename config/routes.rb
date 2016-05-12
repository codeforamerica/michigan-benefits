Rails.application.routes.draw do
  root "landing#show"

  resource :sessions, only: %i[destroy]
  resources :users, only: %i[new create]
end
