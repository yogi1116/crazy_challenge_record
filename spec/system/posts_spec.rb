require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user){ create(:user) } # ユーザーA
  let(:another_user){ create(:user) } # ユーザーB
  let!(:complete_post){ create(:post, :complete, user_id: user.id) } # ユーザーAの投稿
  let!(:give_up_post){ create(:post, :give_up, user_id: another_user.id) } # ユーザーBの投稿

  describe '新規投稿' do
    before do
      login(user)
      find('button', text: 'POST').click
    end

    context '成功' do
      it 'COMPLETEチャレンジの投稿が作成できる' do
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
        using_wait_time(4) do
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content('新規投稿されました')
        end
      end

      it 'GIVE UPチャレンジの投稿が作成できる' do
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
        using_wait_time(4) do
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content('新規投稿されました')
        end
      end
    end

    context '失敗' do
      # title・content・category・images最大アップロード枚数
      # 上記のカラムのバリデーションはCOMPLETEチャレンジ・GIVE UPチャレンジともに同じ設定

      it '挑戦名未入力' do
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
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('挑戦名を入力してください')
        end
      end

      it '挑戦内容未入力' do
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
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('挑戦内容を入力してください')
        end
      end

      it 'カテゴリー未選択' do
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        fill_in 'post[record]', with: 'record'
        # 画像をアップロード
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        click_on '投稿する'
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('カテゴリーを選択してください')
        end
      end

      # GIVE UPチャレンジのみretryカラムにバリデーションを設定
      it 'retryカラム未選択' do
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
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('再挑戦する？を選択してください')
        end
      end

      it '画像アップロード枚数上限(4枚)を超えての投稿' do
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
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('画像アップロードに添付できる枚数は最大4枚です')
        end
      end

      it '有害な投稿内容を含むとNatural language APIにより投稿阻止' do
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: '死・犯罪・災害・戦争・暴力・薬物' # 挑戦内容に有害な単語を記載
        fill_in 'post[record]', with: 'record'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        # カテゴリーを選択(複数選択可。制限なし)
        find("input[type='checkbox'][value='1']").check
        # 画像をアップロード(最大4枚)
        attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png", "#{Rails.root}/spec/fixtures/files/default.png", "#{Rails.root}/spec/fixtures/files/nice_fight_1.png", "#{Rails.root}/spec/fixtures/files/stop_1.png"]
        using_wait_time(4) do
          click_on '投稿する'
          expect(page).to have_content('不適切なコンテンツが含まれています：死や害・ 冒とく・ 違法ドラッグ・ 戦争')
        end
      end
    end
  end

  describe '投稿編集' do
    before do
      login(user)
    end

    it '自分の投稿を編集できる' do
      post_id = complete_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      link = "/posts/#{post_id}/edit"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      fill_in 'post[title]', with: 'edit_title'
      fill_in 'post[content]', with: 'edit_content'
      fill_in 'post[record]', with: 'edit_record'
      fill_in 'post[impression_event]', with: 'edit_implession_event'
      fill_in 'post[lesson]', with: 'lesson'
      # カテゴリ-も変更
      find("input[type='checkbox'][value='3']").check
      find("input[type='checkbox'][value='4']").check
      # 画像を4枚から1枚へ変更
      attach_file 'post[images][]', ["#{Rails.root}/spec/fixtures/files/crazy_1.png"]
      click_on '更新する'
      expect(page).to have_current_path(post_path(post_id))
      expect(page).to have_content('投稿内容を更新しました')
    end

    it '他人の投稿は編集できない' do
      post_id = give_up_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      have_no_content('編集')
    end
  end

  describe '削除' do
    before do
      login(user)
    end

    it '自分の投稿を削除できる' do
      post_id = complete_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      page.accept_confirm do
        find("[action='/posts/#{post_id}'] button[type='submit']").click #ダイアログのOKをクリック
      end
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content('投稿を削除しました')
    end

    it '他人の投稿は削除できない' do
      post_id = give_up_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      have_no_content('削除')
    end
  end
end
