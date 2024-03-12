require 'rails_helper'

RSpec.describe "ChallengePostLike", type: :system do
  let(:user) { create(:user, username: "A") }
  let(:another_user) { create(:user, username: "B") }
  let(:user_challenge_post) { create(:challenge_post, user_id: user.id) }
  let!(:another_user_challenge_post) { create(:challenge_post, user_id: another_user.id) } # いいねされてない状態
  let!(:like) { create(:challenge_post_like, challenge_post: user_challenge_post, user: another_user) } # ユーザーBがいいねした(ユーザーAの投稿)

  describe 'いいね機能' do
    it 'いいねできる' do
      login(user)
      find('button', text: 'CHALLENGE').click
      click_on 'LIST'
      post_id = another_user_challenge_post.id
      link = "/challenge_posts/#{post_id}/challenge_post_likes"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      expect(page).to have_selector('.font-bold', text: '1')
    end

    it 'いいね解除' do
      login(another_user)
      find('button', text: 'CHALLENGE').click
      click_on 'LIST'
      post_id = user_challenge_post.id
      like_id = like.id
      link = "/challenge_posts/#{post_id}/challenge_post_likes/#{like_id}"
      expect(page).to have_selector("a[href='#{link}']")
      expect(page).to have_selector('.font-bold', text: '0')
    end
  end
end