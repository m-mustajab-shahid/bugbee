Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users

  root "dashboard#index"

  # User routes
  resources :users
  get "/profile", to: "users#profile", as: "profile"
  post "/update-profile-photo", to: "users#updateProfilePhoto", as: "update_profile_photo"
  post "/update-profile", to: "users#updateProfile", as: "update_profile"
end
