class CreateChallengePostLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :challenge_post_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
