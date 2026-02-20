Rails.application.routes.draw do
# config/routes.rb
resources :projects do
  member do
    post :add_users
    delete "remove_users/:user_id", to: "projects#remove_users", as: :remove_users
  end
  resources :bugs do
    patch :assign_developer, on: :member
  end
end


  get "dashboard/index"
  devise_for :users

  root "dashboard#index"

  # User routes
  resources :users
  post "/create-user", to: "users#createUser", as: "create_user"
  get "/profile", to: "users#profile", as: "profile"
  post "/update-profile-photo", to: "users#updateProfilePhoto", as: "update_profile_photo"
  post "/update-profile", to: "users#updateProfile", as: "update_profile"
end
