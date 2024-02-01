require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  let(:user) { create(:user) } # ユーザーA
  let(:another_user) { create(:user) } # ユーザーB
  let!(:complete_post) { create(:post, :complete, user_id: user.id) } # ユーザーAの投稿
  let!(:give_up_post) { create(:post, :give_up, user_id: another_user.id) } # ユーザーBの投稿

  describe 'プロフィール編集' do
    before do
      login(user)
    end

    it 'ユーザーは自分のプロフィールを編集できる' do
      find('#hs-dropdown-custom-trigger').click
      click_on 'PROFILE'
      click_on '編集'
      fill_in 'profile[one_word]', with: 'ひとこと'
      fill_in 'profile[birthday]', with: '2024-01-19'
      fill_in 'profile[hobbies]', with: '趣味'
      fill_in 'profile[challenge]', with: 'チャレンジしたいこと'
      fill_in 'profile[introduction]', with: '自己紹介'
      # アバター画像をアップロード
      attach_file('profile[avatar]', 'spec/fixtures/files/comment.png')
      # 背景画像をアップロード
      attach_file('profile[background]', 'spec/fixtures/files/default.png')
      click_on '更新'
    end

    it 'ユーザーは他人のプロフィールを編集できない' do
      user_id = another_user.id
      link = "/users/#{user_id}/profile"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      expect(page).to have_current_path(user_profile_path(user_id))
      expect(page).to have_no_content('編集')
    end
  end

  describe 'プロフィール閲覧' do
    before do
      login(user)
    end

    context '他人のプロフィール' do
      it '投稿一覧画面から遷移' do
        user_id = another_user.id
        link = "/users/#{user_id}/profile"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click # ユーザーBの投稿からユーザーBのアバターをクリック
        expect(page).to have_current_path(user_profile_path(user_id))
      end

      it '投稿詳細画面から遷移' do
        post_id = give_up_post.id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click # ユーザーBの投稿をクリック
        expect(page).to have_current_path(post_path(post_id))
        user_id = another_user.id
        link = "/users/#{user_id}/profile"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click # ユーザーBのアバターをクリック
        expect(page).to have_current_path(user_profile_path(user_id))
      end
    end
  end
end
