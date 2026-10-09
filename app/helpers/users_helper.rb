module UsersHelper
  def role_label(user)
    Role::NAMES.find { |name| user.has_role?(name) }&.humanize
  end
end
