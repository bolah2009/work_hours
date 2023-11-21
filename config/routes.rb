Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # resources 'users', only: %i[new create show update edit]

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy', as: :logout

  # resources :organizations, only: %i[new create index show]

  patch 'password', to: 'passwords#update', as: :edit_password

  resources :organizations, only: %i[new create index show] do
    resources 'users', only: %i[show] do
      resources :metrics, only: %i[new create]
    end
  end
  resources 'users', only: %i[new create edit]

  # Defines the root path route ("/")
  root 'organizations#index'
end
