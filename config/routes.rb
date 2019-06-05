# frozen_string_literal: true

Rails.application.routes.draw do
  # admin routes
  namespace :admin do
    root to: 'dashboard#index'
    resource :dashboard, only: :index
    resources :tips
    resources :mpesa_transactions, only: %i[index show]
    resources :pending_transactions, only: %i[index show]
    resources :marketing_campaigns
    post 'mpesa_transactions/receive', to: 'mpesa_transactions#receive'
    # match 'pending_transactions/:id/retry_transaction', to: 'pending_transactions#retry_transaction', as: :retry_transaction
  end

  # frontend routes
  scope module: 'frontend' do
    resources :home, only: :index
    root to: 'home#index'
  end

  # devise routes
  devise_for :admins, controllers: { confirmations: 'admin/admins/confirmations',
                                     passwords: 'admin/admins/password',
                                     registrations: 'admin/admins/registrations',
                                     sessions: 'admin/admins/sessions',
                                     unlocks: 'admin/admins/unlocks' }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
