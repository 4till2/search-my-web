require 'sidekiq/web'

Rails.application.routes.draw do
  resources :profiles
  resources :accounts
  devise_for :users

  get 'sources', to: 'sources#index', as: 'sources'
  get 'search', to: 'search#new', as: 'new_search'
  post 'search', to: 'search#do', as: 'search'
  get 'import', to: 'import#index', as: 'new_import'
  post 'import', to: 'import#do', as: 'import'
  root 'home#index'

  mount Sidekiq::Web => '/sidekiq'

end
