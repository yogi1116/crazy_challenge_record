require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) } # ユーザーA
  let(:another_user) { create(:user) } # ユーザーB
  let!(:complete_post) { create(:post, :complete, user_id: user.id) } # ユーザーAの投稿
  let!(:give_up_post) { create(:post, :give_up, user_id: another_user.id) } # ユーザーBの投稿

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
        # カテゴリーを選択(最大3つまで選択可)
        check_categories('1', '2', '3')
        # 画像をアップロード(最大4枚)
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
        click_on '投稿する'
        using_wait_time(4) do
          expect(page).to have_content('新規投稿されました')
        end
      end

      it 'GIVE UPチャレンジの投稿が作成できる' do
        click_on 'GIVE UP'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        choose 'post_retry_try' # 挑戦を選択
        check_categories('1', '2', '3')
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
        click_on '投稿する'
        using_wait_time(4) do
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
        choose 'post_retry_try'
        check_categories('1', '2', '3')
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
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
        check_categories('1', '2', '3')
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
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
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
        click_on '投稿する'
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('カテゴリーを選択してください')
        end
      end

      it 'カテゴリーを4つ以上選択すると投稿できない' do
        click_on 'COMPLETE'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        fill_in 'post[record]', with: 'record'
        check_categories('1', '2', '3', '4') # カテゴリーを4つ選択
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
        click_on '投稿する'
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('カテゴリーは最大3つまでです')
        end
      end

      # GIVE UPチャレンジのみretryカラムにバリデーションを設定
      it 'retryカラム未選択' do
        click_on 'GIVE UP'
        fill_in 'post[title]', with: 'title'
        fill_in 'post[content]', with: 'content'
        fill_in 'post[impression_event]', with: 'implession_event'
        fill_in 'post[lesson]', with: 'lesson'
        check_categories('1', '2', '3')
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
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
        check_categories('1', '2', '3')
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png', 'comment.png')
        click_on '投稿する'
        using_wait_time(4) do
          expect(page).to have_content('投稿に失敗しました')
          expect(page).to have_content('画像アップロードに添付できる枚数は最大4枚です')
        end
      end

      it '有害な投稿内容を含むとNatural language APIにより投稿阻止' do
        click_on 'COMPLETE'
        fill_in 'post[title]', with: '死'
        fill_in 'post[content]', with: '災害'
        fill_in 'post[record]', with: '暴力'
        fill_in 'post[impression_event]', with: '戦争'
        fill_in 'post[lesson]', with: '大麻'
        check_categories('1', '2', '3')
        upload_images('crazy_1.png', 'default.png', 'nice_fight_1.png', 'stop_1.png')
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
      link = "/posts/callback?post_id=#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      fill_in 'post[title]', with: 'edit_title'
      fill_in 'post[content]', with: 'edit_content'
      fill_in 'post[record]', with: 'edit_record'
      fill_in 'post[impression_event]', with: 'edit_implession_event'
      fill_in 'post[lesson]', with: 'lesson'
      # カテゴリ-も変更
      check_categories('4', '5')
      # 画像を4枚から1枚へ変更
      upload_images('crazy_1.png')
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

    it '有害な投稿内容を含むとNatural language APIにより投稿阻止' do
      post_id = complete_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      link = "/posts/callback?post_id=#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      fill_in 'post[title]', with: '死'
      fill_in 'post[content]', with: '災害'
      fill_in 'post[record]', with: '暴力'
      fill_in 'post[impression_event]', with: '戦争'
      fill_in 'post[lesson]', with: '大麻'
      using_wait_time(4) do
        click_on '更新する'
        expect(page).to have_content('不適切なコンテンツが含まれています：死や害・ 冒とく・ 違法ドラッグ・ 戦争')
      end
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
        find("[action='/posts/#{post_id}'] button[type='submit']").click # ダイアログのOKをクリック
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

  describe 'ランキング' do
    it 'COMPLETEチャレンジはランキング化される' do
      login(another_user)
      post_id = complete_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      link = "/posts/#{post_id}/likes"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click # いいねをクリック
      click_link 'RANKING'
      expect(page).to have_current_path(ranking_posts_path)
      expect(page).to have_content(complete_post.title)
    end

    it 'GIVE UPチャレンジはランキング化されない' do
      login(user)
      post_id = give_up_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      link = "/posts/#{post_id}/likes"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click # いいねをクリック
      click_link 'RANKING'
      expect(page).to have_current_path(ranking_posts_path)
      expect(page).to have_no_content(give_up_post.title)
    end
  end

  describe '検索' do
    before do
      login(user)
    end

    context '挑戦結果のみの検索ができる' do
      # 現在let!定義によりCOPLETEとGIVE_UP投稿がある状態

      it 'COMPLETE検索' do
        select 'Complete', from: 'q_challenge_result_eq'
        click_button '検索'
        expect(page).to have_content('COMPLETE')
      end

      it 'GIVE UP検索' do
        select 'Give up', from: 'q_challenge_result_eq'
        click_button '検索'
        expect(page).to have_content('GIVE UP')
      end
    end

    context 'カテゴリーのみの検索' do
      # let!定義の投稿は冒険・探究カテゴリーを選択してる

      it 'カテゴリーの検索結果が表示される' do
        find('div[data-target="dropdown-multiselect.dropdown"]').click
        find('a', text: '冒険・探究').click
        click_button '検索'
        post_id = give_up_post.id
        link = "/posts/#{post_id}"
        expect(page).to have_selector("a[href='#{link}']")
        find("a[href='#{link}']").click
        expect(page).to have_content('冒険・探究')
      end

      it '存在しないカテゴリーだと検索結果が空になる' do
        find('div[data-target="dropdown-multiselect.dropdown"]').click
        find('a', text: 'スポーツ').click
        click_button '検索'
        expect(page).to have_content('Read more', count: 0)
      end
    end

    it '挑戦結果とカテゴリーの両方の検索ができる' do
      select 'Complete', from: 'q_challenge_result_eq'
      find('div[data-target="dropdown-multiselect.dropdown"]').click
      find('a', text: '冒険・探究').click
      click_button '検索'
      post_id = complete_post.id
      link = "/posts/#{post_id}"
      expect(page).to have_selector("a[href='#{link}']")
      find("a[href='#{link}']").click
      expect(page).to have_content('COMPLETE')
      expect(page).to have_content('冒険・探究')
    end
  end
end
