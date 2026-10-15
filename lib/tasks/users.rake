namespace :users do
  desc "Create a user: bin/rails users:create EMAIL=... PASSWORD=... ROLE=customer|agent"
  task create: :environment do
    role = ENV["ROLE"]
    abort "ROLE must be #{Role::NAMES.to_sentence(two_words_connector: " or ", last_word_connector: " or ")}" unless Role::NAMES.include?(role)

    user = User.new(email_address: ENV["EMAIL"], password: ENV["PASSWORD"])
    user.add_role(role)

    if user.save
      puts "Created #{role} #{user.email_address}"
    else
      abort "Could not create user: #{user.errors.full_messages.to_sentence}"
    end
  end
end
