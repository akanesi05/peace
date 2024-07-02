class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index ranking ]

  def index
    @poses = Pose.all.order("created_at DESC").limit(6)
  end



  
end
