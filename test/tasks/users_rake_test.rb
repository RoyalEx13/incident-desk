require "test_helper"
require "rake"

class UsersRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("users:create")
    Rake::Task["users:create"].reenable
  end

  test "creates a user with the given role" do
    output = run_create(EMAIL: "new-agent@example.com", PASSWORD: "secret-password", ROLE: "agent")

    user = User.find_by!(email_address: "new-agent@example.com")
    assert user.has_role?(:agent)
    assert user.authenticate("secret-password")
    assert_match "Created agent new-agent@example.com", output
  end

  test "rejects a role other than customer or agent" do
    assert_no_difference -> { User.count } do
      error = run_create_expecting_failure(EMAIL: "new@example.com", PASSWORD: "secret-password", ROLE: "admin")

      assert_match "ROLE must be customer or agent", error
    end
  end

  test "rejects a duplicate email" do
    assert_no_difference -> { User.count } do
      error = run_create_expecting_failure(EMAIL: "customer@example.com", PASSWORD: "secret-password", ROLE: "customer")

      assert_match "Email address has already been taken", error
    end
  end

  test "rejects a missing password" do
    assert_no_difference -> { User.count } do
      error = run_create_expecting_failure(EMAIL: "new@example.com", ROLE: "customer")

      assert_match "Password can't be blank", error
    end
  end

  private
    def run_create(**env)
      with_env(**env) do
        capture_io { Rake::Task["users:create"].invoke }.first
      end
    end

    def run_create_expecting_failure(**env)
      with_env(**env) do
        _out, error = capture_io do
          assert_raises(SystemExit) { Rake::Task["users:create"].invoke }
        end
        error
      end
    end

    def with_env(**env)
      keys = %w[ EMAIL PASSWORD ROLE ]
      original = ENV.to_h.slice(*keys)
      keys.each { |key| ENV.delete(key) }
      env.each { |key, value| ENV[key.to_s] = value }
      yield
    ensure
      keys.each { |key| ENV[key] = original[key] }
    end
end
