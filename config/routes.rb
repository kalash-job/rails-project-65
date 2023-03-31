# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    resource :session, only: %i[destroy]
    resource :profile, only: %i[show]

    resources :bulletins, only: %i[index show new create edit update] do
      member do
        patch :moderate, :archive
      end
    end

    namespace :admin do
      root 'admins#index'
      resources :categories, only: %i[index new create edit update destroy]

      resources :bulletins, only: %i[index] do
        member do
          patch :archive, :publish, :reject
        end
      end
    end
  end
end
