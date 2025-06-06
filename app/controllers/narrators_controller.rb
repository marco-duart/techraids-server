class NarratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_narrator

  def performance_report
    result = Narrator::PerformanceService.new(current_user, performance_report_params).performance_report

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  private

  def performance_report_params
    params.permit(:start_date, :end_date)
  end

  def authorize_narrator
    head :forbidden unless current_user.narrator?
  end
end
