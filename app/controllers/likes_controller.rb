class LikesController < ApplicationController
  before_action :require_user_logged_in

  def create
    micropost = Micropost.find(params[:microposts_id])
    current_user.add_like(micropost)
    flash[:success] = 'お気に入りに追加しました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:microposts_id])
    current_user.del_like(micropost)
    flash[:success] = 'お気に入りから削除しました。'
    redirect_back(fallback_location: root_path)
  end
end
