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
  resources :specializations, only: [ :index, :show, :create, :update, :destroy ]
  resources :character_classes, only: [ :index, :show, :create, :update, :destroy ]
  resources :honorary_titles, only: [ :index, :show, :create, :update, :destroy ]
  resources :guild_notices, only: [ :index ]
  resources :arcane_announcements, only: [ :index ]

  resources :rewards, only: [ :index, :show, :create ] do
    member do
      patch :restock
      patch :remove_stock
    end
  end

  resources :treasure_chests, only: [ :index, :show, :create ] do
    member do
      patch :activate
      patch :deactivate
    end
  end

  # Rotas com regras de negócio para narrator
  # scope :narrator, controller: :narrator do

  # end
  scope :characters, controller: :characters do
    patch "select_specialization", action: :select_specialization
    patch "switch_class", action: :switch_character_class
    patch "switch_title", action: :switch_active_title
    get "character_quest", action: :character_quest
    get "ranking", action: :ranking
    get "purchase_history", action: :purchase_history
    get "store_items", action: :store_items
    post "purchase_chest", action: :purchase_chest
    post "progress_chapter", action: :progress_chapter
    post "defeat_boss", action: :defeat_boss
  end

  scope :narrators do
    get "performance_report", to: "narrators#performance_report"
    get "guild_members", to: "narrators#guild_members"
    get "pending_rewards", to: "narrators#pending_rewards"
    patch "deliver_reward", to: "narrators#deliver_reward"
  end
end
