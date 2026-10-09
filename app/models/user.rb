class User < ApplicationRecord
  ROLES = %w[ customer agent ].freeze

  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def role_name
    ROLES.find { |role| has_role?(role) }
  end
end
