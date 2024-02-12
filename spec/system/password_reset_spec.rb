require 'rails_helper'

RSpec.describe "PasswordResets", type: :system do
  let(:user) { FactoryBot.create(:user, email: 'specific_user@example.com') }

  describe 'ユーザーがパスワードリセットを行う' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'パスワードリセットの成功' do
      reset_token = request_password_reset_for(user.email)

      visit edit_password_reset_path(reset_token)
      fill_in "パスワード", with: "newpassword1"
      fill_in "パスワード確認", with: "newpassword1"
      click_button "パスワードを再設定"
      expect(page).to have_content('パスワードが変更されました')

      fill_in 'email', with: user.email
      fill_in 'password', with: 'newpassword1'
      click_on 'ログイン'
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content('ログインしました')
    end

    context 'パスワードリセットの失敗' do
      it 'パスワード再設定時にパスワード無記入' do
        reset_token = request_password_reset_for(user.email)

        visit edit_password_reset_path(reset_token)
        fill_in "パスワード", with: nil
        fill_in "パスワード確認", with: nil
        click_button "パスワードを再設定"
        expect(page).to have_content('パスワードを入力してください')
      end

      it 'パスワードの不一致' do
        reset_token = request_password_reset_for(user.email)

        visit edit_password_reset_path(reset_token)
        fill_in "パスワード", with: 'password1'
        fill_in "パスワード確認", with: 'password11'
        click_button "パスワードを再設定"
        expect(page).to have_content('パスワードの変更に失敗しました')
        expect(page).to have_content('パスワード確認とパスワードの入力が一致しません')
      end

      it 'パスワードポリシーに反する' do
        reset_token = request_password_reset_for(user.email)

        visit edit_password_reset_path(reset_token)
        fill_in "パスワード", with: '123'
        fill_in "パスワード確認", with: '123'
        click_button "パスワードを再設定"
        expect(page).to have_content('パスワードの変更に失敗しました')
        expect(page).to have_content('パスワードは5文字以上で入力してください')
        expect(page).to have_content('パスワードは英数字をそれぞれ1種類以上含む必要があります')
      end
    end
  end
end