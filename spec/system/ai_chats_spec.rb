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
      expect(page).to have_content('2'), wait: 5
    end

    it 'AIとのチャットは2回まで' do
      fill_in 'body', with: '1+1の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('2'), wait: 5
      fill_in 'body', with: '2+2の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('4'), wait: 5
      fill_in 'body', with: '3+3の答えだけ教えて'
      find('.bg-lime-400').click
      expect(page).to have_content('本日のチャット回数の上限に達しました。')
    end
  end
end