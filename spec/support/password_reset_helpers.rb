module PasswordResetHelpers
  def request_password_reset_for(email)
    visit login_path
    click_link 'パスワードをお忘れの方はこちら'
    fill_in 'メールアドレス', with: email
    expect {
      click_on 'リンクを送信'
      expect(page).to have_content('メールを送信しました')
    }.to change { ActionMailer::Base.deliveries.size }.by(1)

    mail = ActionMailer::Base.deliveries.last
    html_part = mail.parts.detect { |part| part.content_type =~ /text\/html/ }
    decoded_html = html_part.body.decoded
    reset_token = decoded_html.match(/password_resets\/(.*?)\/edit/)[1]
    reset_token
  end
end