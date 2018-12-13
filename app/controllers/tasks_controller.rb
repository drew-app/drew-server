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
    params.require(:task).permit(:title).merge(tags: tags)
  end

  def update_params
    params.require(:task).permit(:title, :done, :started, :description).tap do |update_params|
      update_params.merge!(tags: tags) if params[:tags].present?
    end
  end

  def tags
    Array(params.permit(tags: [])[:tags]).map do |tag_name|
      current_user.tags.find_by('lower(name) = ?', tag_name.downcase) ||
        current_user.tags.create(name: tag_name)
    end
  end
end
