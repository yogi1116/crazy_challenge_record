class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :challenge_result, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.string :record
      t.integer :category, null: false
      t.text :impression_event
      t.text :lesson
      t.text :feedback
      t.integer :retry, null: false

      t.timestamps
    end
  end
end
