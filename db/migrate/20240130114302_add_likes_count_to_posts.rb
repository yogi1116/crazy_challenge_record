class AddLikesCountToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :likes_count, :integer, default: 0, null: false
    Post.find_each { |post| Post.reset_counters(post.id, :likes) }
  end
end
