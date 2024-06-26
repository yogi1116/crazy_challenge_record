require 'rails_helper'

RSpec.describe "AiChat", type: :system do
  let(:user) { create(:user) }

  # テストが終わるたびにRedisのデータをクリアする
  after(:each) do
    $redis.flushdb if Rails.env.test?
  end

  describe 'AIチャット機能' do
    before do
      login(user)
      find("button.z-20").click
    end

    it 'ユーザーはAIとチャットができる' do
      fill_in 'body', with: '1+1の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('2', wait: 5)
      expect(page).to have_content('1+1の答えだけ教えて')
    end

    it 'AIとのチャットは2回まで' do
      fill_in 'body', with: '1+1の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('2', wait: 5)
      expect(page).to have_content('1+1の答えだけ教えて')

      fill_in 'body', with: '2+2の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('4', wait: 5)
      expect(page).to have_content('2+2の答えだけ教えて')

      fill_in 'body', with: '3+3の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('本日のチャット回数の上限に達しました。')
    end

    it '入力文字数が201文字以上だとチャットできない' do
      fill_in 'body', with: 'a' * 201
      find('.bg-lime-400').click
      expect(page).to have_content('200文字以内で入力してください。')
    end
  end
end