class UsersController < ApplicationController
  # ログインしていれば何もしない
  # ログインしていなければログインページへ強制的にリダイレクト
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'

      # users#showへ
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'

      # users/new.html.erbを表示 ※users#newのアクションは実行しない
      render :new
    end
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
