Rails.application.routes.draw do
  post 'populator/update', to: 'pet_populator#update', as: 'populate'
  post 'populator/reconcile', to: 'pet_populator#reconcile', as: 'reconcile'
  get 'pets/search', to: 'pets#search', as: 'search'
  get 'pets/results', to: 'pets#results', as: 'results'
  get 'pets/:id', to: 'pets#show', as: 'show'
  post 'pets/results/subscribe', to: 'pets#subscribe', as: 'subscribe'
  post 'pets/results/unsubscribe', to: 'pets#unsubscribe', as: 'unsubscribe'
  
  root to: 'pets#search'
end
