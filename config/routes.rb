Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :sessions, only: [:new, :create, :destroy]
# config/routes.rb
  
  resources :bookmarks, only: [:create, :destroy]


  
  resources :poses do 
    collection do
      get :bookmarks
    end
  end
  #resources :bookmarks, only: :index
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "poses#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
