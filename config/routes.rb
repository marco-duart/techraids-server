Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth", controllers: {
    sessions: "custom_sessions"
  }

  get "up" => "rails/health#show", as: :rails_health_check

  resources :tasks, only: [ :index, :show, :create, :update, :destroy ]
  resources :missions, only: [ :index, :show, :create, :update, :destroy ]
  resources :guilds, only: [ :index, :show, :create, :update, :destroy ]
  resources :quests, only: [ :index, :show, :create, :update, :destroy ]
  resources :chapters, only: [ :index, :show, :create, :update, :destroy ]
  resources :villages, only: [ :index, :show, :create, :update, :destroy ]
  resources :characters, only: [ :index, :show, :update ]
  resources :treasure_chests, only: [ :index, :show ]
  resources :specializations, only: [ :index, :show, :create, :update, :destroy ]
  resources :character_classes, only: [ :index, :show, :create, :update, :destroy ]

  namespace :characters do
    post "select_specialization", to: "characters#select_specialization"
    post "switch_character_class", to: "characters#switch_character_class"
    get "character_quest", to: "characters#character_quest"
  end
end
