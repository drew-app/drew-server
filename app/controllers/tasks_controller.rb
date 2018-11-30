class TasksController < ApplicationController
  def index
    render json: scope
  end

  def show
    render json: scoped_object
  end

  def create
    render json: scope.create!(create_params)
  end

  def update
    render json: scoped_object.tap { |task| task.update_attributes!(update_params) }
  end

  private

  def scoped_object
    scope.find(params[:id])
  end

  def scope
    current_user.tasks
  end

  def create_params
    params.require(:task).permit(:title)
  end

  def update_params
    params.require(:task).permit(:title, :done, :started, :description)
  end
end
