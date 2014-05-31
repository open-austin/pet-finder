Rails.application.routes.draw do
  resources :users
  resources :notifications
  resources :searches

  root :to => 'searches#index'
end
