class MicropostsController < ApplicationController
    before_action :require_user_logged_in

    # destroyが実行される前に、correct_userを実行
    # correct_user：削除しようとしているMicropostが、
    #  本当にログインユーザが所有しているものかを確認
    before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.feed_microposts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'


    # redirect_back：このアクションが実行されたページに戻る
    #  例えば、toppages#indexで削除ボタンが押されたら、toppages#indexに戻る
    #  fallback_location: root_path：戻るべきページがない場合、root_pathに戻る
    redirect_back(fallback_location: root_path)
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end

end
