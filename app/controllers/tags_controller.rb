class TagsController < ApplicationController
  def index
    render json: scope
  end

  private

  def scope
    current_user.tags
  end
end
