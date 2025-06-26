Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path - handles both authenticated and non-authenticated users
  root "home#index"

  # Authentication routes (public)
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  # User management (protected)
  resources :users, only: [ :create, :show, :edit, :update ] do
    member do
      get :profile  # /users/:id/profile - cleaner profile URL
    end
  end

  # Protected budget app routes - require authentication
  scope constraints: { format: "html" } do
    # Dashboard (main app entry point after login)
    get "dashboard", to: "dashboard#index"

    # Budget management
    resources :categories
    resources :transactions do
      collection do
        get :summary
      end
    end
    resources :budget_plans, path: "budgets"
  end

  # API routes for AJAX requests (also protected)
  namespace :api do
    namespace :v1 do
      resources :transactions, only: [ :index, :show ]
      resources :categories, only: [ :index ]
      get "dashboard/stats", to: "dashboard#stats"
    end
  end
end
