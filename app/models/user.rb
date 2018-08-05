class User < ApplicationRecord
  # メールアドレスを、小文字に変換する
  # ※ !をつけることで、自分自身を対象にする
  before_save { self.email.downcase! }

  # 空欄不可、50桁まで
  validates :name, presence: true, length: { maximum: 50 }

  # 空欄不可、255桁まで
  # フォーマットの指定
  # 重複不可、大文字と小文字の区別なし
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  # パスワードを暗号化して保存する等
  has_secure_password

  # UserからMicropostをみたとき、複数存在するのでhas_many:micropostsとする
  has_many :microposts
end
