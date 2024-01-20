require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user){ create(:user) }
  let(:another_user){ create(:user) }
  let!(:complete_post){ create(:post, :complete, user_id: user.id) } #ユーザーAの投稿
  let!(:give_up_post){ create(:post, :give_up, user_id: another_user.id) } #ユーザーBの投稿

  describe '新規投稿' do
    before do
      visit '/login'
      fill_in 'email', with: user.email
      fill_in 'password', with: 'Password01'
      click_button 'ログイン'
    end

    context '成功' do
      it 'COMPLETEチャレンジの投稿が作成できる' do
        find('button', text: 'POST').click
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[record]', with: 'record'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        # カテゴリーを選択(複数選択可。制限なし)
        find("input[type='checkbox'][value='1']").check
        # 画像をアップロード(最大4枚)
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('新規投稿されました')
      end

      it 'GIVE UPチャレンジの投稿が作成できる' do
        find('button', text: 'POST').click
        click_on 'GIVE UP'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        # 挑戦を選択
        choose 'post_retry_try'
        # カテゴリーを3つ選択
        find("input[type='checkbox'][value='2']").check
        find("input[type='checkbox'][value='3']").check
        find("input[type='checkbox'][value='4']").check
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('新規投稿されました')
      end
    end

    context '失敗' do
      # title・content・category・images最大アップロード枚数
      # 上記のカラムのバリデーションはCOMPLETEチャレンジ・GIVE UPチャレンジともに同じ設定

      it '挑戦名未入力' do
        find('button', text: 'POST').click
        click_on 'GIVE UP'
        fill_in 'post[title]', with: nil
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        # 挑戦を選択
        choose 'post_retry_try'
        # カテゴリーを2つ選択
        find("input[type='checkbox'][value='1']").check
        find("input[type='checkbox'][value='4']").check
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('挑戦名を入力してください')
      end

      it '挑戦内容未入力' do
        find('button', text: 'POST').click
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: nil
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        fill_in 'post[record]', with: 'record'
        # カテゴリーを2つ選択
        find("input[type='checkbox'][value='9']").check
        find("input[type='checkbox'][value='8']").check
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('挑戦内容を入力してください')
      end

      it 'カテゴリー未選択' do
        find('button', text: 'POST').click
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        fill_in 'post[record]', with: 'record'
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('カテゴリーを選択してください')
      end

      # GIVE UPチャレンジのみretryカラムにバリデーションを設定
      it 'retryカラム未選択' do
        find('button', text: 'POST').click
        click_on 'GIVE UP'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        # カテゴリーを2つ選択
        find("input[type='checkbox'][value='10']").check
        find("input[type='checkbox'][value='1']").check
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('再挑戦する？を選択してください')
      end

      it '画像アップロード枚数上限(4枚)を超えての投稿' do
        find('button', text: 'POST').click
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: nil
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        fill_in 'post[record]', with: 'record'
        # カテゴリーを2つ選択
        find("input[type='checkbox'][value='9']").check
        find("input[type='checkbox'][value='8']").check
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png","#{Rails.root}/spec/fixtures/files/comment.png"]
        click_on '投稿する'
        expect(page).to have_content('投稿に失敗しました')
        expect(page).to have_content('画像アップロードに添付できる枚数は最大4枚です')
      end
    end
  end
end
