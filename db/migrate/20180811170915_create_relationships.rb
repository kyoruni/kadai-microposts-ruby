class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      # 外部キーとしてusersテーブルを参照する
      #  何も指定しないと、followsテーブルを参照しようとしてエラーになる
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps

      # user_idとfollow_idのペアに、重複するものが保存されないようにする
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
