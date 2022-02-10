Rails.application.routes.draw do
  resources :profiles
  resources :accounts
  devise_for :users

  root 'home#index'

  # get 'signup', to: 'registrations#new'
  # post 'signup', to: 'registrations#create'
  # get 'login', to: 'sessions#new'
  # post 'login', to: 'sessions#create'
  # delete 'logout', to: 'sessions#destroy'
  # get 'password', to: 'passwords#edit', as: 'edit_password'
  # patch 'password', to: 'passwords#update'

  # resources :users, except: [:index, :new, :create]
end
