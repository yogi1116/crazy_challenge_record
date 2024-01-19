require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user){ create(:user) }
  let(:another_user){ create(:user) }

  before do
    visit '/login'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end

  describe '投稿作成' do
    it 'COMPLETEチャレンジの投稿が作成できる' do
      click_button 'POST'
      visit new_post_path
      click_on 'COMPLETE'
      fill_in 'post[title]', with: 'title'
      fill_in 'post[content]', with: 'content'
      fill_in 'post[record]', with: 'record'
      fill_in 'post[implession_event]', with: 'implession_event'
      fill_in 'post[categories_ids: []]', with: 3
      click_on '投稿する'
    end
  end
end
