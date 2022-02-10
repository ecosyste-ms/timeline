Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # resources :events, constraints: { id: /.*/ }

  get '/events', to: 'events#index', as: :events
  get '/events/*id', to: 'events#show', as: :event

  root "imports#index"
end
