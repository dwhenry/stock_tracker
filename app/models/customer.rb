class Customer < ApplicationRecord
  has_many :customer_stocks, dependent: :destroy
  has_many :accessories, through: :customer_stocks

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
