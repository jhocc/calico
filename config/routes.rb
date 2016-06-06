Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :foster_family_agencies, only: [:index, :show]
  resources :channels, only: [:index, :create] do
    resources :messages, only: [:create]
  end
end
