require 'rails_helper'

RSpec.describe "ChallengePost", type: :system do
  let(:user) { create(:user, username: "A") }
  let(:another_user) { create(:user, username: "B") }
  let!(:user_challenge_post) { create(:challenge_post, user_id: user.id) }
  let!(:another_user_challenge_post) { create(:challenge_post, user_id: another_user.id) }

  describe '新規投稿' do
    before do
      login(user)
      find('button', text: 'CHALLENGE').click
      find("a[href='/challenge_posts/new']").click
    end

    it '投稿できる' do
      fill_in 'challenge_post[title]', with: 'title'
      fill_in 'challenge_post[content]', with: 'content'
      # カテゴリーを選択(最大3つまで選択可)
      check_categories('1', '2', '3')
      click_on '投稿'
      using_wait_time(4) do
        expect(page).to have_content('新規投稿されました')
      end
    end

    context '失敗' do
      it '未入力だと投稿できない' do
        fill_in 'challenge_post[title]', with: ''
        fill_in 'challenge_post[content]', with: ''
        click_on '投稿'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('チャレンジ名を入力してください')
        expect(page).to have_content('チャレンジ内容を入力してください')
        expect(page).to have_content('カテゴリーを選択してください')
      end

      it '未入力だと投稿できない' do
        fill_in 'challenge_post[title]', with: ''
        fill_in 'challenge_post[content]', with: ''
        click_on '投稿'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('チャレンジ名を入力してください')
        expect(page).to have_content('チャレンジ内容を入力してください')
        expect(page).to have_content('カテゴリーを選択してください')
      end

      it '有害な投稿内容を含むとNatural language APIにより投稿阻止' do
        fill_in 'challenge_post[title]', with: '死'
        fill_in 'challenge_post[content]', with: '戦争'
        check_categories('1', '2', '3')
        using_wait_time(4) do
          click_on '投稿'
          expect(page).to have_content('不適切なコンテンツが含まれています：死や害・ 戦争')
        end
      end
    end
  end

  describe '投稿編集' do
    before do
      login(user)
      find('button', text: 'CHALLENGE').click
      click_on 'LIST'
    end

    it '自分の投稿は編集できる' do
      post_id = user_challenge_post.id
      link = "/challenge_posts/#{post_id}/edit"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      fill_in 'challenge_post[title]', with: 'edit_title'
      fill_in 'challenge_post[content]', with: 'edit_content'
      check_categories('4', '5') # カテゴリ-も変更
      click_on '更新'
      expect(page).to have_content('投稿内容を更新しました')
    end

    it '他人の投稿は編集できない' do
      post_id = another_user_challenge_post.id
      link = "/challenge_posts/#{post_id}/edit"
      expect(page).to have_no_selector("a[href='#{link}']")
    end

    it '有害な投稿内容を含むとNatural language APIにより投稿阻止' do
      post_id = user_challenge_post.id
      link = "/challenge_posts/#{post_id}/edit"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      fill_in 'challenge_post[title]', with: '死'
      fill_in 'challenge_post[content]', with: '戦争'
      check_categories('4', '5')
      click_on '更新'
      expect(page).to have_content('不適切なコンテンツが含まれています：死や害・ 戦争')
    end
  end

  describe '削除' do
    before do
      login(user)
      find('button', text: 'CHALLENGE').click
      click_on 'LIST'
    end

    it '自分の投稿を削除できる' do
      post_id = user_challenge_post.id
      expect(page).to have_selector("form[action='/challenge_posts/#{post_id}'] button[type='submit']")
      page.accept_confirm do
        find("[action='/challenge_posts/#{post_id}'] button[type='submit']").click # ダイアログのOKをクリック
      end
      expect(page).to have_content('投稿を削除しました')
    end

    it '他人の投稿は削除できない' do
      post_id = another_user_challenge_post.id
      expect(page).to have_no_selector("form[action='/challenge_posts/#{post_id}'] button[type='submit']")
    end
  end

  describe '検索' do
    before do
      login(user)
      find('button', text: 'CHALLENGE').click
      click_on 'LIST'
    end

    it 'カテゴリー検索ができる' do
      find('div[data-target="dropdown-multiselect.dropdown"]').click
      find('a', text: '冒険・探究').click
      click_button '検索'
      expect(page).to have_content('冒険・探究')
    end

    it '存在しない投稿は表示されない' do
      find('div[data-target="dropdown-multiselect.dropdown"]').click
      find('a', text: 'スポーツ').click
      click_button '検索'
      expect(page).to have_no_content('スポーツ')
    end
  end
end