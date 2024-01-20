module LoginSupport
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Password01'
    click_button 'ログイン'
    expect(page).to have_current_path(posts_path)
  end
end