Rails.application.routes.draw do
  devise_for :users
  root to: "groups#index"
  resources :groups,only: [:index, :new, :create, :destroy] do
    resources :games
    namespace :api do
      resources :games, only: :index, defaults: { format: 'json' }
    end
  end
  resources :kous, only: [:create]
end
