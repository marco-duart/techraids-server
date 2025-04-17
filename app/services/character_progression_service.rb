class CharacterProgressionService
  def initialize(user)
    @user = user
  end

  def switch_character_class(character_class_id)
    character_class = CharacterClass.find(character_class_id)
    authorize_switch_class(character_class)

    if @user.gold >= character_class.entry_fee && @user.experience >= character_class.required_experience
      @user.update(character_class_id: character_class.id, gold: @user.gold - character_class.entry_fee)
      { success: true, user: @user }
    else
      { success: false, error: "Você não tem recursos suficientes para trocar de classe." }
    end
  end

  def select_specialization(specialization_id)
    specialization = Specialization.find(specialization_id)
    authorize_select_specialization(specialization)

    if @user.update(specialization_id: specialization.id)
      { success: true, user: @user }
    else
      { success: false, errors: @user.errors.full_messages }
    end
  end

  private

  def authorize_switch_class(character_class)
    raise Pundit::NotAuthorizedError unless CharacterPolicy.new(@user, character_class).switch_class?
  end

  def authorize_select_specialization(specialization)
    raise Pundit::NotAuthorizedError unless CharacterPolicy.new(@user, specialization).select_specialization?
  end
end
