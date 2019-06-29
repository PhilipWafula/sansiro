# frozen_string_literal: true

Rails.application.routes.draw do
  # admin routes
  namespace :admin do
    root to: 'dashboard#index'
    resource :dashboard, only: :index
    resources :tips
    resources :mpesa_transactions, only: %i[index show]
    resources :pending_transactions
    post 'resolve_pending_transactions', to: 'pending_transactions#resolve_pending_transactions'
    resources :error_handling
    post 'error_handling/test_africas_talking', to: 'error_handling#test_africas_talking'
    resources :marketing_campaigns
    post 'receive', to: 'mpesa_transactions#receive'
    match 'pending_transactions/retry_transaction', to: 'pending_transactions#retry_transaction', as: :retry_transaction, via: :post
    resources :resolved_transactions
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
