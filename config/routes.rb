Rails.application.routes.draw do
  root "dashboard#index"

  resources :customers do
    resources :customer_stocks
    resource :checkout, only: [:new, :create]
  end

  resources :accessories

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
