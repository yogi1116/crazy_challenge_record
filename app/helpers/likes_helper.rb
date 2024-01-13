module LikesHelper
  def like_image_for(post)
    case [post.challenge_result, post.retry]
    when ['complete', nil ]
      'likes/crazy_2.png'
    when ['give_up', 'try']
      'likes/fight_2.png'
    when ['give_up', 'no_try']
      'likes/nice_fight_2.png'
    end
  end

  def like_count_for_button(post, button_type)
    post.likes_count_by_button_type[button_type] || 0
  end
end