Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :tweets, defaults: {format: :json}

  root to: 'static_pages#index'
end
