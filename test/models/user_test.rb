require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "is valid with a customer or an agent role" do
    %w[ customer agent ].each do |role|
      user = User.new(email_address: "#{role}-new@example.com", password: "secret-password")
      user.add_role(role)

      assert user.valid?, user.errors.full_messages.to_sentence
    end
  end

  test "requires a role" do
    user = User.new(email_address: "new@example.com", password: "secret-password")

    assert_not user.valid?
    assert_includes user.errors[:roles], "can't be blank"
  end

  test "rejects a role other than customer or agent" do
    user = User.new(email_address: "new@example.com", password: "secret-password")
    user.add_role(:admin)

    assert_not user.valid?
  end

  test "requires a unique email address, ignoring case" do
    user = User.new(email_address: "CUSTOMER@example.com", password: "secret-password")
    user.add_role(:customer)

    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "reports its role" do
    assert users(:agent).has_role?(:agent)
    assert_not users(:agent).has_role?(:customer)
    assert users(:customer).has_role?(:customer)
  end
end
