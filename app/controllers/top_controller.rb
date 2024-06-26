class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    #@pose = Pose.find_by(params[:id])
    @poses = Pose.all.order("created_at DESC").limit(6)
  end



  
end
