class PosesController < ApplicationController
  def index
    #@poses = Pose.where.not(image: nil).includes(:user).order(created_at: :desc)
    @q = Pose.ransack(params[:q])
    @poses = @q.result(distinct: true).where.not(image: nil).includes(:user).order(created_at: :desc)#.page(params[:page])
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
    @pose = current_user.poses.find(params[:id])
    
  end
    
  def update
    @pose = current_user.poses.find(params[:id])
    if @pose.update(pose_params)
      redirect_to pose_path(@pose), success: t('defaults.flash_message.updated', item: Pose.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Pose.model_name.human)
      render :edit, status: :unprocessable_entity
    end

  end
    
  def destroy
    pose = current_user.poses.find(params[:id])
    pose.destroy!
    redirect_to poses_path, success: t('defaults.flash_message.deleted', item: Pose.model_name.human), status: :see_other
  
  end

  def bookmarks
    #@bookmark_poses = current_user.bookmark_poses.includes(:user).order(created_at: :desc)
    @q = current_user.bookmark_poses.ransack(params[:q])
    @bookmark_poses = @q.result(distinct: true).includes(:user).order(created_at: :desc)#.page(params[:page])
    
  end
  
  private
    
  def pose_params
      params.require(:pose).permit(:name, :image)
  end
end
