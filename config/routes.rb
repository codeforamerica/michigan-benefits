Rails.application.routes.draw do
  root "landing#show"

  resources :users
end
