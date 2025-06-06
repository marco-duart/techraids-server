module Character
  class RankingService
    def initialize(user)
      @user = user
      @guild = user.guild
    end

    def guild_ranking
      return { success: false, error: "Personagem não pertence a nenhuma guild!" } unless @guild

      characters = @guild.characters

      {
        success: true,
        data: {
          missions_completed: ranking_by_missions_completed(characters),
          tasks_completed: ranking_by_tasks_completed(characters),
          gold_earned: ranking_by_gold_earned(characters),
          experience: ranking_by_experience(characters),
          bosses_killed: ranking_by_bosses_killed(characters)
        }
      }
    end

    private

    def ranking_by_missions_completed(characters)
      characters.left_joins(:character_missions)
                .where(missions: { status: :approved })
                .group("users.id")
                .order("COUNT(missions.id) DESC")
                .limit(10)
                .pluck("users.nickname, COUNT(missions.id) as count")
    end

    def ranking_by_tasks_completed(characters)
      characters.left_joins(:character_tasks)
                .where(tasks: { status: :approved })
                .group("users.id")
                .order("COUNT(tasks.id) DESC")
                .limit(10)
                .pluck("users.nickname, COUNT(tasks.id) as count")
    end

    def ranking_by_gold_earned(characters)
      characters.left_joins(:character_missions)
                .where(missions: { status: :approved })
                .group("users.id")
                .order("SUM(missions.gold_reward) DESC")
                .limit(10)
                .pluck("users.nickname, SUM(missions.gold_reward) as total_gold")
    end

    def ranking_by_experience(characters)
      characters.order(experience: :desc)
                .limit(10)
                .pluck(:nickname, :experience)
    end

    def ranking_by_bosses_killed(characters)
      characters.left_joins(:defeated_bosses)
                .group("users.id")
                .order("COUNT(bosses.id) DESC")
                .limit(10)
                .pluck("users.nickname, COUNT(bosses.id) as bosses_killed")
    end
  end
end
