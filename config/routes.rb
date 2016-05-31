Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: [:show]
  resources :resources, only: [:index, :show]
end
