module ChatRouteHelpers
  def visit_user_profile(user_uuid)
    link = "/users/#{user_uuid}/profile"
    expect(page).to have_selector("a[href='#{link}']")
    find("a[href='#{link}']").click
  end

  def visit_user_messages(user_uuid)
    link = "/messages/#{user_uuid}"
    expect(page).to have_selector("a[href='#{link}']")
    find("a[href='#{link}']").click
  end
end