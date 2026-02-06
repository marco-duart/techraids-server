class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :show, :update, :destroy ]

  def index
    @tasks = policy_scope(Task)
    @tasks = apply_filters(@tasks)
    @tasks = apply_sort(@tasks)
    @pagy, @tasks = pagy(@tasks)
    render json: { data: @tasks, pagy: pagy_to_json(@pagy) }
  end

  def show
    authorize @task
    render json: @task
  end

  def create
    @task = Task.new(create_task_params)
    @task.character = current_user
    @task.narrator = current_user.guild.narrator if current_user.guild
    authorize @task

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @task
    if @task.update(update_task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def create_task_params
    params.require(:task).permit(:title, :description)
  end

  def update_task_params
    params.require(:task).permit(:status, :experience_reward)
  end

  def apply_filters(relation)
    relation = relation.filter_by_status(params[:status]) if params[:status].present?

    if params[:experience_reward_min].present? || params[:experience_reward_max].present?
      relation = relation.filter_by_experience_reward(
        params[:experience_reward_min],
        params[:experience_reward_max]
      )
    end

    # Narrators can filter by character, characters cannot
    if current_user.narrator? && params[:character_id].present?
      relation = relation.filter_by_character(params[:character_id])
    end

    relation
  end

  def apply_sort(relation)
    field = params[:sort_by] || :updated_at
    direction = params[:sort_direction] || :desc
    relation.sort_by_field(field, direction)
  end

  def pagy_to_json(pagy_obj)
    {
      count: pagy_obj.count,
      page: pagy_obj.page,
      pages: pagy_obj.pages,
      from: pagy_obj.from,
      to: pagy_obj.to
    }
  end
end
