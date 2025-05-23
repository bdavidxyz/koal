class User < ApplicationRecord
  include Rabarber::HasRoles
  include SearchableResource

  searchable_attributes :email

  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end


  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }
  validates :name, allow_nil: true, length: { minimum: 4 }
  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  after_create :generate_decent_slug
  def generate_decent_slug
    self.slug = "user_#{SecureRandom.hex[0...4]}a#{id}"
    self.save
  end

  after_create :welcome_as_member
  def welcome_as_member
    self.assign_roles(:member)
  end
end
