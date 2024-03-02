require 'rails_helper'

RSpec.describe "Messages", type: :system do
  let(:user) { create(:user) } # ユーザーA
  let(:another_user) { create(:user) } # ユーザーB
  let!(:complete_post_A) { create(:post, :complete, user_id: user.id) } # ユーザーAの投稿
  let!(:complete_post_B) { create(:post, :complete, user_id: another_user.id) } # ユーザーBの投稿

  describe 'チャット機能' do
    it 'ユーザーAはメッセージを送信でき、ユーザーBはリアルタイムでメッセージを受信できる' do
      using_session('user') do
        login(user)
        user_uuid = another_user.uuid
        visit_user_profile(user_uuid) # ユーザーBのプロフィールへ
        visit_user_messages(user_uuid) # ユーザーBとのチャットへ
        fill_in 'message[body]', with: 'おはよう'
        find('.bg-lime-400').click # 送信ボタンをクリック
        expect(page).to have_content('おはよう')
      end

      using_session('another_user') do
        login(another_user)
        user_uuid = user.uuid
        visit_user_profile(user_uuid) # ユーザーAのプロフィールへ
        visit_user_messages(user_uuid) # ユーザーAとのチャットへ
        expect(page).to have_content('おはよう')
      end
    end

    it '画像を送信できる' do
      login(user)
      user_uuid = another_user.uuid
      visit_user_profile(user_uuid) # ユーザーBのプロフィールへ
      visit_user_messages(user_uuid)
      attach_file('message[image]', 'spec/fixtures/files/comment.png', make_visible: true)
      find('.bg-lime-400').click # 送信ボタンをクリック
      sleep 1 # 非同期処理のため待ち時間必須（messageがnilになるの防ぐ目的）
      message = Message.order(created_at: :desc).first
      expect(page).to have_selector("img[src='/uploads/message/image/#{message.id}/comment.png']")
    end
  end
end