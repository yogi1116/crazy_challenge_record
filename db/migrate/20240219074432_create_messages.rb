class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
