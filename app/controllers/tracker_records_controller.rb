class TrackerRecordsController < ApplicationController
  def index
    render json: scope
  end

  def create
    render json: scope.create!
  end

  private

  def scope
    current_user.trackers.find(params[:tracker_id]).tracker_records
  end
end
