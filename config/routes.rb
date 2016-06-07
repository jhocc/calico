Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :foster_family_agencies, only: [:index, :show]
  resources :channels, only: [:index, :create] do
    put :mark
    resources :messages, only: [:create]
  end

  # Avatar routes
  get "avatar/:size/:background/:text" => Dragonfly.app.endpoint { |params, app|
    app.generate(:initial_avatar,
                 URI.unescape(params[:text]),
                 {
                   size: params[:size],
                   background_color: params[:background],
                   font: 'Helvetica'
                 })
  }, as: :avatar
end
