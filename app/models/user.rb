class User < ApplicationRecord
  # メールアドレスを、小文字に変換する
  # ※ !をつけることで、自分自身を対象にする
  before_save { self.email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }

  # 空欄不可、255桁まで
  # フォーマットの指定
  # 重複不可、大文字と小文字の区別なし
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  # パスワードを暗号化して保存する等
  has_secure_password

  has_many :microposts
  has_many :relationships

  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverses_of_relationship, source: :user
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'

  has_many :likes
  has_many :liked_microposts, through: :likes, source: :micropost

  # フォローしようとしている other_user が自分自身ではないかを検証
  # 見つかれば Relation を返し、見つからなければフォロー関係をcreate(build + save)
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  # relationshipが存在すればdestroy
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # self.followingsによりフォローしているUser達を取得
  # include?(other_user)で、other_userが含まれていないかを確認
  # 含まれている場合にはtrue、含まれていなければfalse
  def following?(other_user)
    self.followings.include?(other_user)
  end

  # フォローユーザ + 自分自身のポストを取得する
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

  # お気に入り登録 / 既にお気に入り登録していなければ、お気に入りへ追加する
  def add_like(liked_micropost_id)
    self.likes.find_or_create_by(user_id: self.id, micropost_id: liked_micropost_id.id)
  end

  # お気に入り削除 / 既にお気に入り登録していたら、お気に入りから削除する
  def del_like(liked_micropost_id)
    like = self.likes.find_by(user_id: self.id, micropost_id: liked_micropost_id.id)
    like.destroy if like
  end

  # お気に入り確認 / 既にお気に入り登録していたらtrue、していなければfalse
  def liked?(liked_micropost)
    self.liked_microposts.include?(liked_micropost)
  end
end
