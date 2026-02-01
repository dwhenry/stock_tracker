class Accessory < ApplicationRecord
  has_one_attached :image
  has_many :customer_stocks, dependent: :destroy
  has_many :customers, through: :customer_stocks

  validates :name, presence: true
  validates :alert_when_stock_below, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :barcode, presence: true, uniqueness: true
end
