require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "allows only customer and agent" do
    assert Role.new(name: "customer").valid?
    assert Role.new(name: "agent").valid?
    assert_not Role.new(name: "admin").valid?
  end
end
