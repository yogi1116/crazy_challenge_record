require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe '会員登録' do
    before do
      visit root_path
      expect(page).to have_content('SIGNUP')
      visit new_user_path
    end

    context '成功' do
      it 'ユーザーの新規登録ができる' do
        fill_in 'user[username]', with: 'test01'
        fill_in 'user[email]', with: 'test01@example.com'
        fill_in 'user[password]', with: 'Password01'
        fill_in 'user[password_confirmation]', with: 'Password01'
        check 'user_agreement'
        click_on '登録'
        expect(page).to have_current_path(login_path)
        expect(page).to have_content('ユーザー登録が完了しました')
      end
    end

    context '失敗' do
      it '同じメールアドレスのユーザーは新規登録できない' do
        fill_in 'user[username]', with: 'test01'
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: 'Password01'
        fill_in 'user[password_confirmation]', with: 'Password01'
        check 'user_agreement'
        click_on '登録'
        expect(page).to have_current_path(new_user_path)
        expect(page).to have_content('ユーザー登録に失敗しました')
      end

      it 'ユーザーネームが入力されてない場合は新規登録できない' do
        fill_in 'user[username]', with: nil
        fill_in 'user[email]', with: 'test01@example.com'
        fill_in 'user[password]', with: 'Password01'
        fill_in 'user[password_confirmation]', with: 'Password01'
        check 'user_agreement'
        click_on '登録'
        expect(page).to have_current_path(new_user_path)
        expect(page).to have_content('ユーザー登録に失敗しました')
        expect(page).to have_content('ユーザーネームを入力してください')
      end

      it 'メールアドレスが入力されてない場合は新規登録できない' do
        fill_in 'user[username]', with: 'test01'
        fill_in 'user[email]', with: nil
        fill_in 'user[password]', with: 'Password01'
        fill_in 'user[password_confirmation]', with: 'Password01'
        check 'user_agreement'
        click_on '登録'
        expect(page).to have_current_path(new_user_path)
        expect(page).to have_content('ユーザー登録に失敗しました')
        expect(page).to have_content('メールアドレスを入力してください')
      end

      it 'パスワードが入力されてない場合は新規登録できない' do
        fill_in 'user[username]', with: 'test01'
        fill_in 'user[email]', with: 'test01@example.com'
        fill_in 'user[password]', with: nil
        fill_in 'user[password_confirmation]', with: 'Password01'
        check 'user_agreement'
        click_on '登録'
        expect(page).to have_current_path(new_user_path)
        expect(page).to have_content('ユーザー登録に失敗しました')
        expect(page).to have_content('パスワードを入力してください')
      end

      it 'パスワード確認が入力されてない場合は新規登録できない' do
        fill_in 'user[username]', with: 'test01'
        fill_in 'user[email]', with: 'test01@example.com'
        fill_in 'user[password]', with: 'Password01'
        fill_in 'user[password_confirmation]', with: nil
        check 'user_agreement'
        click_on '登録'
        expect(page).to have_current_path(new_user_path)
        expect(page).to have_content('ユーザー登録に失敗しました')
        expect(page).to have_content('パスワード確認を入力してください')
      end

      it '同意をクリックしないと新規登録できない' do
        fill_in 'user[username]', with: 'test01'
        fill_in 'user[email]', with: 'test01@example.com'
        fill_in 'user[password]', with: 'Password01'
        fill_in 'user[password_confirmation]', with: 'Password01'
        click_on '登録'
        expect(page).to have_current_path(new_user_path) # 会員登録できてないためログイン画面に遷移できない
      end
    end
  end
end
