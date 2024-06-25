class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @pose = Pose.find_by(params[:id])
  end



  
end
