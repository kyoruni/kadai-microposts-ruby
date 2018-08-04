module SessionsHelper
  # @current_user に既に現在のログインユーザが代入されていたら何もしない
  # 代入されていなかったら User.findからログインユーザを取得し、@current_userに代入
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # ユーザがログインしていればtrue ログインしていなければfalse
  def logged_in?
    !!current_user
  end
end
