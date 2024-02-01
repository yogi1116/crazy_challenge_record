require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) } # ユーザーA
  let(:another_user) { create(:user) } # ユーザーB
  let(:complete_post) { create(:post, :complete, user_id: user.id) } # ユーザーAの投稿
  let(:give_up_post) { create(:post, :give_up, user_id: another_user.id) } # ユーザーBの投稿
  let!(:comment_post_A) { create(:comment, post: complete_post, user: user) } # ユーザーAが自分の投稿にコメント
  let!(:comment_post_B) { create(:comment, post: complete_post, user: another_user) } # ユーザーBがユーザーAの投稿にコメント

  describe 'コメント機能' do
    before do
      login(user) # ユーザーAでログイン
    end

    context 'コメント投稿' do
      it 'ユーザーは自分の投稿にコメントできる' do
        post_id = comment_post_A.post_id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click # 投稿詳細のリンク(READ MOREをクリック)
        fill_in 'comment[body]', with: 'コメント'
        click_on '投稿'
        expect(page).to have_content('コメント')
      end

      it '他人の投稿にコメントできる' do
        post_id = comment_post_B.post_id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click # 投稿詳細のリンク(READ MOREをクリック)
        fill_in 'comment[body]', with: 'コメント'
        click_on '投稿'
        expect(page).to have_content('コメント')
      end
    end

    context 'コメント失敗' do
      it '無記入は投稿できない' do
        post_id = comment_post_A.post_id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click # 投稿詳細のリンク(READ MOREをクリック)
        fill_in 'comment[body]', with: nil
        click_on '投稿'
        expect(page).to have_content('コメント内容を入力してください')
      end
    end
  end

  describe '自分のコメントの編集削除' do
    before do
      login(user)
      post_id = comment_post_A.post_id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click # 投稿詳細のリンク(READ MOREをクリック)
    end

    it '自分のコメントが編集できる' do
      post_id = comment_post_A.post_id
      comment_id = comment_post_A.id
      link = "/posts/#{post_id}/comments/#{comment_id}/edit"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click # 編集ボタンクリック
      within("turbo-frame#comment_#{comment_id}") do
        fill_in 'comment[body]', with: 'RUNTEQ卒業'
        click_on '更新する' # 既存のコメントをRUNTEQ卒業に変更した
      end
      expect(page).to have_content('RUNTEQ卒業')
    end

    it '自分のコメントを削除できる' do
      post_id = comment_post_A.post_id
      comment_id = comment_post_A.id
      link = "/posts/#{post_id}/comments/#{comment_id}"
      expect(page).to have_selector("a[href='#{link}']")
      page.accept_confirm do
        find("a[href='#{link}']").click # 削除ボタンをクリック、ダイアログが表示される
      end
      expect(page).to have_no_selector("a[href='#{link}']") # 削除ボタンがない == 自分のコメントが消えた
    end
  end

  describe '他人のコメント編集削除' do
    before do
      login(user)
      post_id = comment_post_B.post_id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click # 投稿詳細のリンク(READ MOREをクリック)
    end

    it '他人のコメントは編集できない' do
      post_id = comment_post_B.post_id
      comment_id = comment_post_B.id
      link = "/posts/#{post_id}/comments/#{comment_id}/edit"
      expect(page).to have_no_selector("a[href='#{link}']") # コメントの編集リンクがないか確認
    end

    it '他人のコメントは削除できない' do
      post_id = comment_post_B.post_id
      comment_id = comment_post_B.id
      link = "/posts/#{post_id}/comments/#{comment_id}"
      expect(page).to have_no_selector("a[href='#{link}']") # コメントの削除リンクがないか確認
    end
  end

  describe 'コメントカウントの反映' do
    it 'コメントすると投稿詳細・投稿一覧のコメントカウントが増える' do
      login(user)
      post_id = comment_post_A.post_id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click # 投稿詳細のリンク(READ MOREをクリック)
      fill_in 'comment[body]', with: 'コメント'
      click_on '投稿'
      expect(page).to have_selector('turbo-frame#count .font-bold', text: '3') # let!の定義により、ユーザーAとBがすでに2件コメントしている状態だった
      visit posts_path
      expect(page).to have_selector('.font-bold', text: '3')
    end
  end
end
