Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'top_pages#top'
  get '/login',  to: 'user_sessions#new'
  post '/login',  to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'
  get '/privacy_policy', to: 'top_pages#privacy_policy'

  resources :users, only: %i[new create] do
    resource :profile, only: %i[show]
  end
  resource :profile, only: %i[show edit update]
  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create edit update destroy]
    collection do
      get 'ranking'
    end
  end
end
