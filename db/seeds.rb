# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Demo accounts. Passwords come from SEED_CUSTOMER_PASSWORD / SEED_AGENT_PASSWORD;
# development and test fall back to an obvious dev-only value.
{ "customer" => "customer@example.com", "agent" => "agent@example.com" }.each do |role, email_address|
  password_key = "SEED_#{role.upcase}_PASSWORD"
  password = ENV.fetch(password_key) { Rails.env.local? ? "password" : abort("Set #{password_key} to seed #{email_address}") }

  User.find_or_create_by!(email_address: email_address) do |user|
    user.password = password
    user.add_role(role)
  end
end
