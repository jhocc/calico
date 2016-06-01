Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :resources, only: [:index, :show]
  resources :messages, only: [:index]
end
