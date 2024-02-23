Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  mount ActionCable.server => '/cable'

  root 'top_pages#top'
  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'
  get '/privacy_policy', to: 'top_pages#privacy_policy'
  get '/terms_of_service', to: 'top_pages#terms_of_service'

  resources :users, param: :uuid, only: %i[new create] do
    resource :profile, only: [:show]
  end
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create edit update destroy]
    collection do
      get 'ranking'
      get 'reset_search'
      get 'callback'
    end
  end
  resources :messages, only: %i[index create show destroy]
end
