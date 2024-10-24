class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def show
    # @poses= Pose.where(user_id: current_user.id)
    @poses = current_user.poses.page(params[:page]).per(6)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t("defaults.flash_message.updated", item: User.model_name.human)
    else
      flash.now["danger"] = t("defaults.flash_message.not_updated", item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(current_user.id)
    end

    def user_params
      params.require(:user).permit(:email, :name, :avatar, :avatar_cache, :favorite_genre)
    end
end
