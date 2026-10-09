require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:customer) }

  test "signed-out visitor is redirected to sign in" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "new shows the sign-in form" do
    get new_session_path

    assert_response :success
    assert_select "form[action=?]", session_path do
      assert_select "input[type=email][name=email_address]"
      assert_select "input[type=password][name=password]"
      assert_select "button[type=submit]", "Sign in"
    end
    assert_select ".alert-error", count: 0
  end

  test "new has no password reset link" do
    get new_session_path

    assert_select "a", text: /forgot/i, count: 0
  end

  test "password reset routes are removed" do
    get "/passwords/new"

    assert_response :not_found
  end

  test "create with valid credentials lands on the dashboard" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with a wrong password re-renders sign in with an error" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
    assert_nil cookies[:session_id]
  end

  test "create with an unknown email shows the same error" do
    post session_path, params: { email_address: "nobody@example.com", password: "password" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
  end

  test "destroy ends the session and protected pages redirect to sign in" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]

    get root_path
    assert_redirected_to new_session_path
  end
end
