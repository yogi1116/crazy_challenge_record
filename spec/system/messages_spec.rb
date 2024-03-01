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
  end
end