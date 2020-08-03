Rails.application.routes.draw do
  devise_for :users
  root to: "groups#index"
  resources :games, only: [:index] 
  resources :groups,only: [:index, :new, :create]
end
