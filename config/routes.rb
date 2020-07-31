Rails.application.routes.draw do
  root to: "groups#index"
  resources :games, only: [:index] 
end
