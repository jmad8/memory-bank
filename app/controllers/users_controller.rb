class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update]
  helper_method :sort_param, :direction_param

  def new
    @user = User.new
    render layout: "application"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to #{app_name}!"
      log_in @user
      redirect_to memories_path
    else
      render 'new', layout: "application"
    end
  end

  def edit
    render layout: "application"
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to memories_path
    else
      render 'edit'
    end
  end

  private
    def set_user
      @user = current_user
      if @user == nil
        log_out
        logged_in_user
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def sort_param
      %w[first_name last_name].include?(params[:sort]) ? params[:sort] : "first_name"
    end

    def direction_param
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
