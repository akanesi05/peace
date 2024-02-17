class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  #def create
    #@user = User.new(user_params)
    #if @user.save
      #redirect_to root_path
    #else
      #render :new
  #end

  #def show
      #@user = User.find(params[:id])
  #end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  

  #def ranking
    #@bookmark= User.find(Bookmark.group(:user_id).order('count(pose_id) desc').limit(10).pluck(:user_id))
  #end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
