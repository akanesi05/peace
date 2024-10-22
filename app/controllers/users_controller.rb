class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @poses = Pose.where(user_id: @user.id).order(created_at: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: t(".success")
    else
      flash.now[:danger] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
