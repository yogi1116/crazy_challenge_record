class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :one_word
      t.date :birthday
      t.string :challenge
      t.text :hobbies
      t.text :introduction

      t.timestamps
    end
  end
end
