require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires a unique email address" do
    user = User.new(email_address: "CUSTOMER@example.com", password: "secret123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "role_name reflects the rolify role" do
    assert_equal "customer", users(:customer).role_name
    assert_equal "agent", users(:agent).role_name
    assert users(:agent).has_role?(:agent)
    assert_not users(:agent).has_role?(:customer)
  end
end
