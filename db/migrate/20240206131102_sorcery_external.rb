class SorceryExternal < ActiveRecord::Migration[7.1]
  def change
    create_table :authentications do |t|
      t.integer :user_id, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps              null: false
    end

    add_index :authentications, [:provider, :uid]
    add_index :authentications, :user_id
  end
end
