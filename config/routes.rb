Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root to: "campaigns#home"
  get 'dashboard', to: 'campaigns#dashboard'
  get 'pricing', to: 'pages#pricing'
  get 'terms', to: 'pages#terms'
  get 'stripe_accounts/full', to: 'stripe_accounts#full'

  resources :campaigns

  resources :stripe_accounts

  resources :charges

  resources :bank_accounts
end
