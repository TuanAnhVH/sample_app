class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t "controllers.microposts.created"
      redirect_to root_url
    else
      save_fail
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "controllers.microposts.deleted"
    else
      flash[:danger] = t "controllers.microposts.delete_fail"
    end
    redirect_to request.referer || root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "controllers.microposts.access_error"
    redirect_to root_path
  end

  def save_fail
    @feed_items = current_user.feed.paginate(page: params[:page],
      per_page: Settings.paging.pg_10)
    render "static_pages/home"
  end
end
