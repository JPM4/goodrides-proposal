Rails.application.routes.draw do
  root to: "static_pages#root"

  resources :users, only: [:show, :new, :create]
  resource :session

  namespace :api, defaults: { format: :json } do
    resources :rides, only: [:index, :show]
    resources :reviews, only: [:create, :update, :destroy, :show]
  end
end
