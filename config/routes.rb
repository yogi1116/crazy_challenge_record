Rails.application.routes.draw do
  root 'top_pages#top'
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'
  get '/privacy_policy', to: 'top_pages#privacy_policy'
  get '/terms_of_service', to: 'top_pages#terms_of_service'

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
