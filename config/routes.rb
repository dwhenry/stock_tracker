Rails.application.routes.draw do
  # Authentication
  resource :session
  resources :passwords, param: :token

  # User management (admin only)
  resources :users, except: [:show] do
    member do
      post :resend_invitation
    end
  end

  # Invitation acceptance
  get "invitation/accept/:token", to: "invitations#accept", as: :accept_invitation
  post "invitation/complete/:token", to: "invitations#complete", as: :complete_invitation

  # Main application
  root "dashboard#index"

  resources :customers do
    resources :customer_stocks
    resource :checkout, only: [:new, :create]
  end

  resources :accessories

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
