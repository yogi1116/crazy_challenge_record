class CreateChallengePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :challenge_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
