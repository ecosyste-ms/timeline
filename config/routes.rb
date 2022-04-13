Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'
  
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :events, constraints: { id: /.*/ }, only: [:index, :show] 
    end
  end

  get '/events', to: 'events#index', as: :events
  get '/events/*id', to: 'events#show', as: :event

  root "imports#index"
end
