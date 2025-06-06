module Character
  class StoreService
    def initialize(user)
      @user = user
    end

    def purchase_chest(treasure_chest_id)
      chest = TreasureChest.with_available_rewards.find_by(id: treasure_chest_id)
      return { success: false, error: "Baú não encontrado ou sem recompensas disponíveis" } unless chest

      authorize_purchase_chest(chest)

      if @user.gold >= chest.value
        reward = select_random_reward(chest)

        ActiveRecord::Base.transaction do
          @user.update!(gold: @user.gold - chest.value)
          CharacterTreasureChest.create!(
            character: @user,
            treasure_chest: chest,
            reward: reward
          )
          reward.decrement!(:stock_quantity) if reward.is_limited
        end

        { success: true, data: { reward: reward } }
      else
        { success: false, error: "Gold insuficiente" }
      end
    rescue ActiveRecord::RecordInvalid => e
      { success: false, error: e.message }
    rescue Pundit::NotAuthorizedError
      { success: false, error: "Não autorizado a comprar este baú" }
    end

    def purchase_history
      authorize_view_purchase_history

      history = @user.character_treasure_chests
                .includes(:treasure_chest, :reward)
                .order(created_at: :desc)
                .map do |character_chest|
        {
          id: character_chest.id,
          purchased_at: character_chest.created_at,
          last_updated: character_chest.updated_at,
          chest: character_chest.treasure_chest,
          reward: character_chest.reward
        }
      end

      { success: true, data: { purchase_history: history } }
    rescue Pundit::NotAuthorizedError
      { success: false, error: "Não autorizado a ver o histórico" }
    end

    def store_items
      authorize_view_store

      chests = available_chests.map do |chest|
        {
          chest: chest,
          possible_rewards: chest.rewards.available.limit(3),
          rewards_count: chest.rewards.available.count
        }
      end

      { success: true, data: { store_items: chests } }
    rescue Pundit::NotAuthorizedError
      { success: false, error: "Não autorizado a ver a loja" }
    end

    private

    def authorize_purchase_chest(chest)
      raise Pundit::NotAuthorizedError unless CharacterPolicy.new(@user, chest).purchase_chest?
    end

    def authorize_view_purchase_history
      raise Pundit::NotAuthorizedError unless CharacterPolicy.new(@user, @user).view_purchase_history?
    end

    def authorize_view_store
      raise Pundit::NotAuthorizedError unless CharacterPolicy.new(@user, @character).view_store?
    end

    def select_random_reward(chest)
      chest.rewards.available.sample
    end

    def available_chests
      TreasureChest.where(guild_id: @user.guild_id)
                  .with_available_rewards
                  .active
    end
  end
end
