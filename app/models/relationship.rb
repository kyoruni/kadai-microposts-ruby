class Relationship < ApplicationRecord
  belongs_to :user
  # follow_idがUserクラスを参照するように設定
  #  何も指定しないと、存在しないFollowを参照しようとしてエラーになる
  belongs_to :follow, class_name: 'User'

  validates :user_id, presence: true
  validates :follow_id, presence: true
end
