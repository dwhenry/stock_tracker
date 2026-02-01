class StockAdjustment < ApplicationRecord
  belongs_to :customer_stock

  validates :quantity_change, presence: true, numericality: { only_integer: true }
  validates :adjustment_type, presence: true, inclusion: { in: %w[addition removal checkout initial] }

  TYPES = {
    addition: "addition",
    removal: "removal",
    checkout: "checkout",
    initial: "initial"
  }.freeze

  scope :recent, -> { order(created_at: :desc) }

  delegate :customer, :accessory, to: :customer_stock
end
