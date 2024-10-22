Rails.application.routes.draw do
  resources :tags
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :users, only: %i[new create show edit]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  resources :sessions, only: [:new, :create, :destroy]

  get "/privacy", to: "static_pages#index"
  # get '/puraibasi', to: 'static_pages#puraibasi'
  # config/routes.rb

  resources :bookmarks, only: [:create, :destroy]

  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]

  resources :poses do
    collection do
      get :bookmarks
      get :ranking
      get :preview
    end
    get :search, on: :collection
  end
  root "top#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
