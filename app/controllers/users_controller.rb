class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :load_user, only: [:edit, :update, :destroy, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.paging.pg_10)
  end

  def show
    @microposts = @user.feed.paginate(page: params[:page],
      per_page: Settings.paging.pg_10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users.check_email_to_active"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "controllers.users.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users.deleted"
    else
      flash[:danger] = t "controllers.users.delete_fail"
    end

    redirect_to users_url
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "controllers.users.refuse_action"
    redirect_to(root_url)
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "controllers.users.refuse_action"
    redirect_to(root_url)
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t "controllers.users.user_not_found"
    redirect_to root_path
  end
end
