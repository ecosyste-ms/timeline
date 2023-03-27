Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'

  mount PgHero::Engine, at: "pghero"
  
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :events, constraints: { id: /.*/ }, only: [:index, :show] do
        collection do
          get :repository_names
        end
        member do
          get :summary
        end
      end
    end
  end

  get '/events', to: 'events#index', as: :events
  get '/events/*id', to: 'events#show', as: :event

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable'
  get '/500', to: 'errors#internal'

  root "imports#index"
end
