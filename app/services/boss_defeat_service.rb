class BossDefeatService
  def initialize(user)
    @user = user
    @current_chapter = user.current_chapter
    @boss = @current_chapter.boss
  end

  def defeat
    return { success: false, error: "Não há boss para derrotar" } unless @boss.present?
    return { success: false, error: "Boss já foi derrotado" } if @boss.defeated?
    return { success: false, error: "Equipe não possui força para derrotar o boss" } unless @boss.team_can_defeat?
    return { success: false, error: "Apenas o herói pode dar o golpe final" } unless @boss.finishing_hero?(@user)

    ActiveRecord::Base.transaction do
      @boss.update!(
        defeated: true,
        finishing_character: @user,
      )
    end

    { success: true }
  rescue => e
    { success: false, error: e.message }
  end
end
