class TrackersController < ApplicationController
  def index
    render json: scope
  end

  def create
    render json: scope.create!(create_params)
  end

  private

  def scope
    current_user.trackers
  end

  def create_params
    params.require(:tracker).permit(:title)
  end
end
