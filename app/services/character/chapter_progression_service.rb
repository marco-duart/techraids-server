module Character
  class ChapterProgressionService
    def initialize(user)
      @user = user
      @current_chapter = user.current_chapter
    end

    def progress
      return { success: false, error: "Você já está no último capítulo" } unless next_chapter
      return { success: false, error: "Experiência insuficiente" } unless has_required_experience?
      return { success: false, error: "Derrote o boss primeiro" } if boss_not_defeated?

      ActiveRecord::Base.transaction do
        @user.update!(current_chapter: next_chapter)
      end

      { success: true, chapter: next_chapter }
    rescue => e
      { success: false, error: e.message }
    end

    private

    def has_required_experience?
      @user.experience >= @current_chapter.required_experience
    end

    def boss_not_defeated?
      @current_chapter.boss.present? && !@current_chapter.boss.defeated?
    end

    def next_chapter
      @next_chapter ||= @current_chapter.quest.chapters
                                      .where("position > ?", @current_chapter.position)
                                      .order(:position)
                                      .first
    end
  end
end
