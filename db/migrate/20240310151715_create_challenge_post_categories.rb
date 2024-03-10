class CreateChallengePostCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :challenge_post_categories do |t|
      t.references :challenge_post, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
