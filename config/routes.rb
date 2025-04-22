Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [ :index, :show, :destroy ]
  resource  :password, only: [ :edit, :update ]
  namespace :identity do
    resource :email,              only: [ :edit, :update ]
    resource :email_verification, only: [ :show, :create]
    resource :password_reset,     only: [ :new, :edit, :create, :update ]
  end
  post "users/:user_id/masquerade", to: "masquerades#create", as: :user_masquerade
  get "home/index"
  get "myaccount", to: "myaccount#index"
  get "myaccount/sessions", to: "myaccount#sessions"
  get "myaccount/password", to: "myaccount#password"
  get "myaccount/profile", to: "myaccount#profile"
  get "myaccount/billing", to: "myaccount#billing"
  get "myaccount/danger", to: "myaccount#danger"
  delete "myaccount/destroy", to: "myaccount#destroy_account"
  root to: "home#index"
end
