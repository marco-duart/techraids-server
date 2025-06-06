module Narrator
  class PerformanceService
    def initialize(user, params)
      @user = user
      @start_date = (params[:start_date] || Date.current.beginning_of_month).beginning_of_day
      @end_date = (params[:end_date] || Date.current).end_of_day
    end

    def performance_report
      authorize_performance_report

      characters = @user.managed_guild.characters.includes(:character_tasks, :character_missions)

      report_data = characters.map do |character|
        {
          character_id: character.id,
          nickname: character.nickname,
          tasks: task_stats(character),
          missions: mission_stats(character),
          overall_performance: calculate_performance(character)
        }
      end

      {
        success: true,
        message: "Relatório de desempenho gerado com sucesso.",
        data: {
          period: { start_date: @start_date, end_date: @end_date },
          guild_name: @user.managed_guild.name,
          report: report_data
        }
      }
    rescue Pundit::NotAuthorizedError
      {
        success: false,
        message: "Você não tem autorização para acessar este relatório."
      }
    rescue => e
      {
        success: false,
        message: "Ocorreu um erro ao gerar o relatório: #{e.message}"
      }
    end

    private

    def authorize_performance_report
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, nil).performance_report?
    end

    def task_stats(character)
      tasks = character.character_tasks.where(created_at: @start_date..@end_date)

      {
        total: tasks.count,
        approved: tasks.approved.count,
        rejected: tasks.rejected.count,
        pending: tasks.pending.count,
        completion_rate: tasks.any? ? (tasks.approved.count.to_f / tasks.count * 100).round(2) : 0
      }
    end

    def mission_stats(character)
      missions = character.character_missions.where(created_at: @start_date..@end_date)

      {
        total: missions.count,
        approved: missions.approved.count,
        rejected: missions.rejected.count,
        pending: missions.pending.count,
        completion_rate: missions.any? ? (missions.approved.count.to_f / missions.count * 100).round(2) : 0
      }
    end

    def calculate_performance(character)
      tasks = character.character_tasks.where(created_at: @start_date..@end_date)
      missions = character.character_missions.where(created_at: @start_date..@end_date)

      total_tasks = tasks.count
      total_missions = missions.count
      approved_tasks = tasks.approved.count
      approved_missions = missions.approved.count

      total_activities = total_tasks + total_missions
      return 0 if total_activities.zero?

      ((approved_tasks + approved_missions).to_f / total_activities * 100).round(2)
    end
  end
end
