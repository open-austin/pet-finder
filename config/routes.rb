Rails.application.routes.draw do
  post 'populator/update', to: 'pet_populator#update', as: 'populate'
  post 'populator/reconcile', to: 'pet_populator#reconcile', as: 'reconcile'
  get 'pets/search', to: 'pets_controller#search', as: 'search'
  get 'pets/results', to: 'pets_controller#results', as: 'results'
  get 'pets/:id', to: 'pets_controller#show', as: 'show'
  post 'pets/results/subscribe', to: 'pets_controller#subscribe', as: 'subscribe'
  
  root to: 'pets#search'
end
