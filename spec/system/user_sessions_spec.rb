require 'rails_helper'

RSpec.describe "Usersessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    before do
      visit login_path
      expect(page).to have_content('LOGIN')
    end

    context '成功' do
      it 'ユーザーはログインできる' do
        fill_in 'email', with: user.email
        fill_in 'password', with: 'Password01'
        click_on 'ログイン'
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('ログインしました')
      end
    end

    context '失敗' do
      it 'メールアドレス未入力時はログインできない' do
        fill_in 'email', with: nil
        fill_in 'password', with: 'Password01'
        click_on 'ログイン'
        expect(page).to have_current_path(login_path)
        expect(page).to have_content('ログインに失敗しました')
      end

      it 'パスワード未入力時はログインできない' do
        fill_in 'email', with: user.email
        fill_in 'password', with: nil
        click_on 'ログイン'
        expect(page).to have_current_path(login_path)
        expect(page).to have_content('ログインに失敗しました')
      end

      it '登録されてないユーザーはログインできない' do
        fill_in 'email', with: 'another_user@example.com'
        fill_in 'password', with: 'Password02'
        click_on 'ログイン'
        expect(page).to have_current_path(login_path)
        expect(page).to have_content('ログインに失敗しました')
      end

      it 'パスワード失敗時はログインできない' do
        fill_in 'email', with: user.email
        fill_in 'password', with: 'Password02'
        click_on 'ログイン'
        expect(page).to have_current_path(login_path)
        expect(page).to have_content('ログインに失敗しました')
      end
    end
  end

  describe 'ログアウト' do
    it 'ユーザーはログアウトできる' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: 'Password01'
      click_on 'ログイン'
      expect(page).to have_current_path(posts_path)
      find('#hs-dropdown-custom-trigger').click
      click_on 'LOGOUT'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('ログアウトしました')
    end
  end
end
