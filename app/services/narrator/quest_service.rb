module Narrator
  class QuestService
    include Rails.application.routes.url_helpers

    HINT_WINDOW_DAYS = 30
    PLANNING_HORIZONS = [ 30, 60, 90 ].freeze

    def initialize(user)
      @user = user
      @guild = user.managed_guild
    end

    def fetch_quest_and_companions
      return { success: false, error: "Narrador não gerencia nenhuma guild!" } if @guild.nil?

      quest = @guild.quest
      return { success: false, error: "Guild não possui uma quest configurada!" } if quest.nil?

      chapters = quest.chapters
                    .includes(boss: { finishing_character: :character_class })
                    .ordered

      guild_members = @guild.characters
                            .includes(:character_class, :current_chapter, :active_title)
                            .to_a
      guild_members_by_chapter = guild_members.group_by(&:current_chapter_id)

      processed_chapters = chapters.map do |chapter|
        process_chapter(chapter, guild_members_by_chapter[chapter.id] || [])
      end

      {
        success: true,
        data: {
          quest: quest,
          guild_resume: build_guild_resume(guild_members),
          hints: build_management_hints(chapters, guild_members),
          chapters: processed_chapters
        }
      }
    end

    private

    def process_chapter(chapter, chapter_members)
      {
        **chapter.as_json,
        guild_members: chapter_members.any? ? chapter_members.map { |m| format_character_data(m) } : nil,
        boss: process_boss(chapter.boss)
      }
    end

    def process_boss(boss)
      return nil unless boss

      finishing_character = boss.finishing_character
      finishing_data = if finishing_character&.character_class
        {
          id: finishing_character.id,
          nickname: finishing_character.nickname,
          image_url: finishing_character.character_class.image.attached? ?
                    rails_blob_url(finishing_character.character_class.image) : nil
        }
      end

      {
        **boss.as_json,
        finishing_character: finishing_data,
        team_can_defeat: boss.team_can_defeat?
      }
    end

    def format_character_data(character)
      character_class = character.character_class
      {
        id: character.id,
        nickname: character.nickname,
        current_level: character.current_level,
        experience: character.experience,
        character_class: {
          name: character_class&.name || "Não selecionada",
          slogan: character_class&.slogan || "",
          image_url: character_class&.image&.attached? ? rails_blob_url(character_class.image) : nil
        },
        current_chapter: character.current_chapter,
        active_title: character.active_title
      }
    end

    def build_guild_resume(guild_members)
      experiences = guild_members.map(&:experience)
      total_members = guild_members.size
      avg_xp = total_members.positive? ? (experiences.sum.to_f / total_members).round(2) : 0.0

      {
        total_members: total_members,
        average_xp: avg_xp,
        min_xp: experiences.min || 0,
        max_xp: experiences.max || 0,
        average_level: total_members.positive? ? (guild_members.sum(&:current_level).to_f / total_members).round(2) : 0.0,
        members_by_chapter: members_distribution_by_chapter(guild_members)
      }
    end

    def build_management_hints(chapters, guild_members)
      member_ids = guild_members.map(&:id)
      tasks_scope = Task.where(character_id: member_ids)
      recent_approved_scope = tasks_scope.approved.where(created_at: HINT_WINDOW_DAYS.days.ago..Time.current)

      recent_approved_count = recent_approved_scope.count
      recent_approved_xp = recent_approved_scope.sum(:experience_reward)
      tasks_per_day = (recent_approved_count.to_f / HINT_WINDOW_DAYS).round(2)
      xp_per_day = (recent_approved_xp.to_f / HINT_WINDOW_DAYS).round(2)
      avg_xp_per_task = recent_approved_count.positive? ? (recent_approved_xp.to_f / recent_approved_count).round(2) : 0.0

      next_boss_context = next_boss_projection(chapters, guild_members, tasks_per_day, xp_per_day)
      scenarios = planning_scenarios(next_boss_context, tasks_per_day)

      {
        analysis_window_days: HINT_WINDOW_DAYS,
        task_pace: {
          approved_tasks_per_day: tasks_per_day,
          approved_tasks_last_window: recent_approved_count,
          average_xp_per_approved_task: avg_xp_per_task,
          estimated_team_xp_per_day: xp_per_day
        },
        next_boss: next_boss_context,
        pacing_scenarios: scenarios,
        recommendations: build_recommendations(tasks_scope, tasks_per_day, next_boss_context, guild_members)
      }
    end

    def next_boss_projection(chapters, guild_members, _tasks_per_day, xp_per_day)
      next_chapter_with_boss = chapters.find { |chapter| chapter.boss.present? && !chapter.boss.defeated? }
      return { available: false, message: "Todos os bosses da quest já foram derrotados." } if next_chapter_with_boss.nil?

      boss = next_chapter_with_boss.boss
      chapter_members = guild_members.select { |member| member.current_chapter_id == next_chapter_with_boss.id }
      chapter_total_xp = chapter_members.sum(&:experience)
      required_xp = boss.defeat_threshold
      xp_gap = [ required_xp - chapter_total_xp, 0 ].max

      eta_days = if xp_gap.zero?
        0
      elsif xp_per_day.positive?
        (xp_gap / xp_per_day).ceil
      end

      {
        available: true,
        chapter_id: next_chapter_with_boss.id,
        chapter_title: next_chapter_with_boss.title,
        boss_id: boss.id,
        boss_name: boss.name,
        team_members_on_chapter: chapter_members.size,
        team_current_xp: chapter_total_xp,
        required_xp: required_xp,
        xp_gap: xp_gap,
        can_defeat_now: xp_gap.zero?,
        estimated_days_to_defeat: eta_days
      }
    end

    def planning_scenarios(next_boss_context, tasks_per_day)
      return [] unless next_boss_context[:available]
      return [] if next_boss_context[:xp_gap].zero?

      xp_gap = next_boss_context[:xp_gap]

      PLANNING_HORIZONS.map do |horizon_days|
        projected_tasks = (tasks_per_day * horizon_days).round
        suggested_xp = if projected_tasks.positive?
          (xp_gap.to_f / projected_tasks).ceil
        end

        {
          horizon_days: horizon_days,
          projected_approved_tasks: projected_tasks,
          suggested_xp_per_task: suggested_xp,
          feasible_with_current_pace: projected_tasks.positive?
        }
      end
    end

    def build_recommendations(tasks_scope, tasks_per_day, next_boss_context, guild_members)
      recommendations = []

      total_tasks = tasks_scope.count
      pending_ratio = total_tasks.positive? ? (tasks_scope.pending.count.to_f / total_tasks) : 0.0
      rejected_ratio = total_tasks.positive? ? (tasks_scope.rejected.count.to_f / total_tasks) : 0.0

      recommendations << "A guild está com baixa cadência de tasks aprovadas. Sugestão: criar metas semanais por membro para elevar o ritmo." if tasks_per_day < 1
      recommendations << "Há acúmulo alto de tasks pendentes. Revise a cadência de aprovação para evitar gargalo de progressão." if pending_ratio >= 0.35
      recommendations << "Taxa de rejeição elevada nas tasks. Alinhe critérios de aceite e exemplos de entregas para reduzir retrabalho." if rejected_ratio >= 0.25

      if next_boss_context[:available]
        if next_boss_context[:can_defeat_now]
          recommendations << "A equipe já tem XP para derrotar o próximo boss. Foque em coordenação para finalizar o capítulo rapidamente."
        elsif next_boss_context[:estimated_days_to_defeat].present?
          recommendations << "Mantendo o ritmo atual, a equipe deve ficar pronta para o próximo boss em #{next_boss_context[:estimated_days_to_defeat]} dias."
        else
          recommendations << "Sem ganho recente de XP, não há projeção de derrota do próximo boss. Defina imediatamente uma política mínima de XP por task aprovada."
        end
      end

      top_contributor_share = top_contributor_share(tasks_scope)
      if top_contributor_share >= 0.5
        recommendations << "Mais de 50% das tasks aprovadas estão concentradas em um único membro. Distribua melhor a carga para reduzir risco operacional."
      end

      recommendations.presence || [ "Ritmo saudável identificado. Continue monitorando semanalmente cadência de approvals e XP médio por task." ]
    end

    def top_contributor_share(tasks_scope)
      approved_counts = tasks_scope.approved.group(:character_id).count
      total_approved = approved_counts.values.sum
      return 0.0 if total_approved.zero?

      approved_counts.values.max.to_f / total_approved
    end

    def members_distribution_by_chapter(guild_members)
      guild_members.group_by(&:current_chapter).map do |chapter, members|
        {
          chapter_id: chapter&.id,
          chapter_title: chapter&.title || "Sem capítulo",
          members_count: members.size
        }
      end
    end
  end
end
