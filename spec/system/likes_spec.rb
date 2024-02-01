require 'rails_helper'

RSpec.describe "Likes", type: :system do
  let(:user) { create(:user) } # ユーザーA
  let(:another_user) { create(:user) } # ユーザーB
  let!(:complete_post) { create(:post, :complete, user_id: user.id) } # ユーザーAの投稿
  let!(:give_up_post) { create(:post, :give_up, user_id: another_user.id) } # ユーザーBの投稿
  let(:like) { create(:like, post: give_up_post, user: user) } # ユーザーAがいいねしてる状態

  describe 'いいね機能' do
    before do
      login(user)
    end

    context 'いいね機能の挙動確認' do
      it '他人の投稿にいいねできる' do
        post_id = give_up_post.id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click
        link = "/posts/#{post_id}/likes"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click
        expect(page).to have_selector("#likes_count-#{post_id}", text: '1') # いいねカウントが0から１になる
      end

      it 'いいねの取り消し' do
        post_id = like.post_id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click
        like_id = like.id
        link = "/posts/#{post_id}/likes/#{like_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click
        expect(page).to have_selector("#likes_count-#{post_id}", text: '0') # いいねが1から0になる
      end
    end

    it 'いいね後投稿一覧画面のいいねカウントが更新される' do
      post_id = give_up_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      link = "/posts/#{post_id}/likes"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      expect(page).to have_selector("#likes_count-#{post_id}", text: '1')
      visit posts_path
      expect(page).to have_selector('.font-bold', text: '1')
    end

    it 'いいねボタンは表示されず投稿の編集削除が表示される' do
      post_id = complete_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')
    end
  end
end
