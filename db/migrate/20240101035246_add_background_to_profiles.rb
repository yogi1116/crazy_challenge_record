class AddBackgroundToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :background, :string
  end
end
