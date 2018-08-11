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

  # UserからMicropost/relationshipsをみたとき、複数存在するのでhas_many:microposts/relationthipとする
  has_many :microposts
  has_many :relationships

  # relationshipからuserをみたときも、複数存在する
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'

  # has_many: relationships/reverses_of_relationshipの結果を中間テーブルとして指定
  #  参照先のidを:follow/userとする
  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverses_of_relationship, source: :user

  # フォローしようとしている other_user が自分自身ではないかを検証
  # 見つかれば Relation を返し、見つからなければフォロー関係をcreate(build + save)
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    # relationshipが存在すればdestroy
    relationship.destroy if relationship
  end

  # self.followingsによりフォローしているUser達を取得
  # include?(other_user)で、other_userが含まれていないかを確認
  # 含まれている場合にはtrue、含まれていなければfalse
  def following?(other_user)
    self.followings.include?(other_user)
  end
end
