# Demo accounts. Passwords come from SEED_CUSTOMER_PASSWORD / SEED_AGENT_PASSWORD;
# outside production they fall back to the dev-only value "password".
default_password = Rails.env.production? ? nil : "password"

{
  "customer" => [ "customer@example.com", ENV.fetch("SEED_CUSTOMER_PASSWORD", default_password) ],
  "agent" => [ "agent@example.com", ENV.fetch("SEED_AGENT_PASSWORD", default_password) ]
}.each do |role, (email, password)|
  raise "Set SEED_#{role.upcase}_PASSWORD to seed the #{role} account." if password.blank?

  user = User.find_or_create_by!(email_address: email) do |new_user|
    new_user.password = password
  end
  user.add_role(role) unless user.has_role?(role)
end
