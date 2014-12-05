Rails.application.routes.draw do
  
  root 'pets#search'

  post 'populator/update', to: 'pet_populator#update', as: 'populate'
  post 'populator/reconcile', to: 'pet_populator#reconcile', as: 'reconcile'
  
  get 'pets/search', to: 'pets#search', as: 'search'
  get 'pets/results', to: 'pets#results', as: 'results'
  get 'pets/:id', to: 'pets#show', as: 'show'

  get 'confirm', to: 'subscription#confirm', as: 'confirm'
  post 'confirm', to: 'subscription#confirm'
  post 'subscribe', to: 'subscription#subscribe', as: 'subscribe'
  get 'unsubscribe', to: 'subscription#unsubscribe', as: 'unsubscribe'
  post 'unsubscribe', to: 'subscription#unsubscribe'
  
end
