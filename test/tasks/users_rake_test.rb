require "test_helper"
require "rake"

class UsersRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("users:create")
    @env = ENV.to_h.slice("EMAIL", "PASSWORD", "ROLE")
  end

  teardown do
    %w[ EMAIL PASSWORD ROLE ].each { |key| ENV[key] = @env[key] }
  end

  test "creates a user with the given role" do
    output, _ = run_task(EMAIL: "New.Agent@example.com", PASSWORD: "s3cret-pass", ROLE: "agent")

    user = User.find_by!(email_address: "new.agent@example.com")
    assert user.has_role?(:agent)
    assert user.authenticate("s3cret-pass")
    assert_match "Created agent new.agent@example.com", output
  end

  test "rejects an invalid role" do
    assert_task_fails "ROLE must be one of: customer, agent", EMAIL: "x@example.com", PASSWORD: "pw", ROLE: "admin"
  end

  test "rejects a duplicate email" do
    assert_task_fails "already exists", EMAIL: "Customer@example.com", PASSWORD: "pw", ROLE: "customer"
  end

  test "rejects a missing password" do
    assert_task_fails "PASSWORD is required", EMAIL: "x@example.com", PASSWORD: nil, ROLE: "customer"
  end

  test "rejects an invalid email" do
    assert_task_fails "Email address is invalid", EMAIL: "not-an-email", PASSWORD: "pw", ROLE: "customer"
  end

  private
    def run_task(**vars)
      vars.each { |key, value| ENV[key.to_s] = value }
      task = Rake::Task["users:create"]
      task.reenable
      capture_io { task.invoke }
    end

    def assert_task_fails(message, **vars)
      error = assert_no_difference("User.count") do
        assert_raises(SystemExit) { run_task(**vars) }
      end

      assert_not error.success?
      assert_match message, error.message
    end
end
