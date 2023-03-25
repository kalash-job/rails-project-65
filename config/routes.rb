# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'users/index'
  scope module: :web do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    resources :bulletins, except: %i[destroy]
    resource :session, only: %i[destroy]
  end
end
