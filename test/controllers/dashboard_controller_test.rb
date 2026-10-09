require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "signed-out visitors are redirected to sign-in" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "shows the signed-in customer and their role with the top nav" do
    sign_in_as users(:customer)

    get root_path

    assert_response :success
    assert_select ".topbar .brand", "Incident Desk"
    assert_select ".topbar .user", /customer@example.com · Customer/
    assert_select ".topbar form[action='#{session_path}'] button", "Log out"
    assert_select "h1", /customer@example.com/
    assert_select ".role-customer", "Customer"
  end

  test "shows the agent role for agents" do
    sign_in_as users(:agent)

    get root_path

    assert_select ".role-agent", "Agent"
  end
end
