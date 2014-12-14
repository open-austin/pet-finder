Rails.application.routes.draw do
  
  root 'pets#search'

  post 'populator/update', to: 'pet_populator#update', as: 'populate'
  post 'populator/reconcile', to: 'pet_populator#reconcile', as: 'reconcile'
  get 'pets/without-images', to: 'pet_populator#pets_without_images'
  post 'pet/:id/reconcile-image', to: 'pet_populator#reconcile_image'
  
  get 'search', to: 'pets#search', as: 'search'
  get 'results', to: 'pets#results', as: 'results'
  get 'pet/:id', to: 'pets#show', as: 'show'

  post 'subscribe', to: 'subscription#subscribe', as: 'subscribe'
  match 'confirm', to: 'subscription#confirm', as: 'confirm', via: [ :get, :post ]
  match 'unsubscribe', to: 'subscription#unsubscribe', as: 'unsubscribe', via: [ :get, :post ]
  
end
