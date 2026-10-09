require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:customer) }

  test "new renders the sign-in form" do
    get new_session_path

    assert_response :success
    assert_select "input[type=email][name=email_address]"
    assert_select "input[type=password][name=password]"
    assert_select "input[type=submit][value='Sign in']"
    assert_select ".topbar", count: 0
  end

  test "new redirects to the dashboard when already signed in" do
    sign_in_as @user

    get new_session_path

    assert_redirected_to root_path
  end

  test "create with valid credentials redirects to the dashboard" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with a wrong password re-renders sign-in with an error" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: "Invalid email or password"
    assert_nil cookies[:session_id]
  end

  test "create with an unknown email shows the same error" do
    post session_path, params: { email_address: "nobody@example.com", password: "password" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: "Invalid email or password"
  end

  test "destroy ends the session and protected pages are no longer accessible" do
    sign_in_as @user

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]

    get root_path
    assert_redirected_to new_session_path
  end

  test "password reset routes are not available" do
    assert_not Rails.application.routes.url_helpers.respond_to?(:new_password_path)
  end
end
