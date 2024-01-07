class PosesController < ApplicationController
  def index
    @poses = Pose.where.not(image: nil)
  end
    
  def show
     @pose = Pose.find(params[:id])
  end
    
  def new
     @pose = Pose.new
  end
    
  def create
    @pose = current_user.poses.build(pose_params)
     if @pose.save
          redirect_to @pose, notice: 'Pose was successfully created.'
     else
      render :new
     end
  end
    
  def edit
    @pose = Pose.find(params[:id])
  end
    
  def update
    @pose = Pose.find(params[:id])
     if @pose.update(pose_params)
       redirect_to @pose, notice: 'Pose was successfully updated.'
     else
        render :edit
     end
  end
    
  def destroy
    @pose = Pose.find(params[:id])
    @pose.destroy
    redirect_to poses_url, notice: 'Pose was successfully destroyed.'
  end
    
  private
    
  def pose_params
      params.require(:pose).permit(:name, :image)
  end
end
