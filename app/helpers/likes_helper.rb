module LikesHelper
  def like_image_for(post)
    case [post.challenge_result, post.retry]
    when ['complete', nil ]
      'likes/crazy_2'
    when ['give_up', 'try']
      'likes/fight_2'
    when ['give_up', 'no_try']
      'likes/nice_fight_2'
    end
  end
end