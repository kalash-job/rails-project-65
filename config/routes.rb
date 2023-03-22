# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/index'
  root 'users#index'
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    resource :session, only: %i[destroy]
  end
end
