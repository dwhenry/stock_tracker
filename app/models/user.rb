class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :role, presence: true, inclusion: { in: %w[basic admin] }

  ROLES = %w[basic admin].freeze

  scope :ordered, -> { order(:name) }

  def admin?
    role == "admin"
  end

  def basic?
    role == "basic"
  end

  def invited?
    invitation_token.present? && password_digest.blank?
  end

  def generate_invitation_token!
    update!(
      invitation_token: SecureRandom.urlsafe_base64(32),
      invitation_sent_at: Time.current
    )
  end

  def accept_invitation!(password:)
    update!(
      password: password,
      invitation_token: nil,
      invitation_sent_at: nil
    )
  end

  def invitation_valid?
    invitation_token.present? && invitation_sent_at.present? && invitation_sent_at > 7.days.ago
  end

  private

  def password_required?
    # Password required if not invited (accepting invitation) or if password is being set
    !invited? || password.present?
  end
end
