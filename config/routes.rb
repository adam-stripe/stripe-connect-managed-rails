Rails.application.routes.draw do
  devise_for :users
  root to: "campaigns#home"
  get 'dashboard', to: 'campaigns#dashboard'
  get 'pricing', to: 'pages#pricing'

  resources :campaigns

  resources :stripe_accounts

  resources :charges

  resources :bank_accounts
end
