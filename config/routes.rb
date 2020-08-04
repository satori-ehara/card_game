Rails.application.routes.draw do
  devise_for :users
  root to: "groups#index"
  resources :groups,only: [:index, :new, :create] do
    resources :games, only: [:index] 
  end
end
