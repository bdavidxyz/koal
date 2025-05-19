Rails.application.routes.draw do
  #
  # Account-related routes
  #
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [ :destroy ]
  resource  :password, only: [ :update ]
  namespace :identity do
    resource :email,              only: [ :update ]
    resource :email_verification, only: [ :show, :create ]
    resource :password_reset,     only: [ :new, :edit, :create, :update ]
  end
  # post "users/:user_id/masquerade", to: "masquerades#create", as: :user_masquerade
  get "home/index"
  get "myaccount", to: "myaccount#index"
  get "myaccount/sessions", to: "myaccount#sessions"
  get "myaccount/email", to: "myaccount#email"
  get "myaccount/password", to: "myaccount#password"
  get "myaccount/profile", to: "myaccount#profile"
  get "myaccount/billing", to: "myaccount#billing"
  get "myaccount/danger", to: "myaccount#danger"
  delete "myaccount/destroy", to: "myaccount#destroy_account"

  #
  # Admin dashboard: Users
  #
  scope path: "myaccount/users", as: "myaccount_user" do
    get    "/",            to: "myaccount_users#index", as: :list
    get    "/new",          to: "myaccount_users#new"
    post   "/",            to: "myaccount_users#create", as: :create
    get    "/:slug",        to: "myaccount_users#show"
    get    "/:slug/edit",   to: "myaccount_users#edit", as: :edit
    put    "/:slug",        to: "myaccount_users#update", as: :update
    delete "/:slug",        to: "myaccount_users#destroy", as: :destroy
  end
  #
  # Admin dashboard: BlogArticles
  #
  scope path: "myaccount/blog_articles", as: "myaccount_blogarticle" do
    get    "/",            to: "myaccount_blogarticles#index", as: :list
    get    "/new",          to: "myaccount_blogarticles#new"
    post   "/",            to: "myaccount_blogarticles#create", as: :create
    get    "/:slug",        to: "myaccount_blogarticles#show"
    get    "/:slug/edit",   to: "myaccount_blogarticles#edit", as: :edit
    put    "/:slug",        to: "myaccount_blogarticles#update", as: :update
    delete "/:slug",        to: "myaccount_blogarticles#destroy", as: :destroy
  end
  #
  # Pages routes
  #
  root to: "home#index"
end
