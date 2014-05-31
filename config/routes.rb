Rails.application.routes.draw do
  resources :notifications
  resources :searches
  resources :users

  root :to => 'searches#index'
end
