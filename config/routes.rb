Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth", controllers: {
    sessions: "custom_sessions",
    token_validations: "custom_token_validations",
    registrations: "registrations"
  }

  get "up" => "rails/health#show", as: :rails_health_check

  resources :public do
    collection do
      get "guilds", to: "guilds#simple_list"
    end
  end

  resources :users do
    collection do
      patch "update_password"
      patch "update_photo"
    end
  end

  resources :tasks, only: [ :index, :show, :create, :update, :destroy ]
  resources :missions, only: [ :index, :show, :create, :update, :destroy ]
  resources :guilds, only: [ :index, :show, :create, :update, :destroy ]
  resources :quests, only: [ :index, :show, :create, :update, :destroy ]
  resources :chapters, only: [ :index, :show, :create, :update, :destroy ]
  resources :villages, only: [ :index, :show, :create, :update, :destroy ]
  resources :treasure_chests, only: [ :index, :show ]
  resources :specializations, only: [ :index, :show, :create, :update, :destroy ]
  resources :character_classes, only: [ :index, :show, :create, :update, :destroy ]

  # Rotas com regras de negócio para narrator
  # scope :narrator, controller: :narrator do

  # end
  scope :characters, controller: :characters do
    patch "select_specialization", action: :select_specialization
    patch "switch_class", action: :switch_character_class
    get "character_quest", action: :character_quest
    get "ranking", action: :ranking
  end
end
