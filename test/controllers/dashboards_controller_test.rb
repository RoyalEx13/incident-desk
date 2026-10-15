require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "signed-out visitor is redirected to sign in" do
    get dashboard_path

    assert_redirected_to new_session_path
  end

  test "greets a customer with their email and role" do
    sign_in_as users(:customer)

    get root_path

    assert_response :success
    assert_select "main", /customer@example\.com/
    assert_select "main", /Customer/
  end

  test "greets an agent with their email and role" do
    sign_in_as users(:agent)

    get root_path

    assert_response :success
    assert_select "main", /agent@example\.com/
    assert_select "main", /Agent/
  end

  test "shows the top nav with the signed-in user and a log out button" do
    sign_in_as users(:agent)

    get root_path

    assert_select "header.topbar" do
      assert_select ".brand", "Incident Desk"
      assert_select ".user", /agent@example\.com · Agent/
      assert_select "form[action=?]", session_path do
        assert_select "input[name=_method][value=delete]"
        assert_select "button", "Log out"
      end
    end
  end
end
