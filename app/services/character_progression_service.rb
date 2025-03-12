class CharacterProgressionService
  def initialize(user)
    @user = user
  end

  def switch_character_class(character_class_id)
    character_class = CharacterClass.find(character_class_id)
    authorize_switch(character_class)

    if @user.gold >= character_class.entry_fee && @user.experience >= character_class.required_experience
      @user.update(character_class_id: character_class.id, gold: @user.gold - character_class.entry_fee)
      { success: true, user: @user }
    else
      { success: false, error: "Você não tem recursos suficientes para trocar de classe." }
    end
  end

  def select_specialization(specialization_id)
    authorize_select

    if @user.update(specialization_id: specialization_id)
      { success: true, user: @user }
    else
      { success: false, errors: @user.errors.full_messages }
    end
  end

  private

  def authorize_switch(character_class)
    raise Pundit::NotAuthorizedError unless CharacterPolicy.new(@user, character_class).switch?
  end

  def authorize_select
    raise Pundit::NotAuthorizedError unless SpecializationPolicy.new(@user, @user).select?
  end
end
