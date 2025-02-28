Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth"

      get "up" => "rails/health#show", as: :rails_health_check

      resources :tasks, only: [ :index, :show, :create, :update, :destroy ]
      resources :missions, only: [ :index, :show, :create, :update, :destroy ]
      resources :guilds, only: [ :index, :show, :create, :update, :destroy ]
      resources :quests, only: [ :index, :show, :create, :update, :destroy ]
      resources :characters, only: [ :index, :show, :update ]
      resources :treasure_chests, only: [ :index, :show ]
    end
  end
end
