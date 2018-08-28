class TasksController < ApplicationController
  def index
    render json: Task.all
  end

  def create
    task = Task.create!(create_task_params)
    render json: task
  end

  def update
    task = Task.find(params[:id])
    task.update_attributes(update_task_params)
    render json: task
  end

  private

  def create_task_params
    params.require(:task).permit(:title)
  end

  def update_task_params
    params.require(:task).permit(:title, :done, :started, :description)
  end
end
