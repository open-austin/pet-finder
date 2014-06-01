Rails.application.routes.draw do
  post 'populator/update', to: 'pet_populator#update', as: 'populate'
  post 'populator/reconcile', to: 'pet_populator#reconcile', as: 'reconcile'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :notifications
  resources :searches do
  	collection do
  		get :show_all
  	end
  end
  resources :users

  root :to => 'searches#index'
end
