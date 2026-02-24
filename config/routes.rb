Rails.application.routes.draw do
resources :projects do
  member do
    post :add_users
    post :add_comments
    delete "remove_users/:user_id", to: "projects#remove_users", as: :remove_users
  end
  resources :bugs do
    patch :assign_developer, on: :member
    patch :changet_to_in_progress, on: :member
    patch :change_to_close, on: :member
    patch :change_to_reopen, on: :member
    patch :change_to_resolve, on: :member
    post :add_bug_comments, on: :member
  end
end


  get "dashboard/index"
  devise_for :users

  root "dashboard#index"

  # User routes
  resources :users
  post "/create-user", to: "users#create_user", as: "create_user"
  get "/profile", to: "users#profile", as: "profile"
  post "/update-profile-photo", to: "users#update_profile_photo", as: "update_profile_photo"
  post "/update-profile", to: "users#update_profile", as: "update_profile"
end
