namespace :users do
  desc "Create a user: bin/rails users:create EMAIL=agent@example.com PASSWORD=... ROLE=customer|agent"
  task create: :environment do
    email, password, role = ENV.values_at("EMAIL", "PASSWORD", "ROLE")

    abort "EMAIL is required." if email.blank?
    abort "PASSWORD is required." if password.blank?
    abort "ROLE must be one of: #{User::ROLES.join(", ")}." unless User::ROLES.include?(role)
    abort "A user with email #{email.strip.downcase} already exists." if User.exists?(email_address: email.strip.downcase)

    user = User.new(email_address: email, password: password)

    User.transaction do
      user.save!
      user.add_role(role)
    end

    puts "Created #{role} #{user.email_address}."
  rescue ActiveRecord::RecordInvalid
    abort "Could not create user: #{user.errors.full_messages.to_sentence}."
  end
end
