module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_task, only: [ :show, :update, :destroy ]

      def index
        @tasks = policy_scope(Task)
        render json: @tasks
      end

      def show
        authorize @task
        render json: @task
      end

      def create
        @task = Task.new(task_params)
        @task.character = current_user
        authorize @task

        if @task.save
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize @task
        if @task.update(task_params)
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

      def task_params
        params.require(:task).permit(:title, :description, :status, :experience_reward)
      end
    end
  end
end
