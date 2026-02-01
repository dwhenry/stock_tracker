class CustomerStock < ApplicationRecord
  belongs_to :customer
  belongs_to :accessory
  has_many :stock_adjustments, dependent: :destroy

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :accessory_id, uniqueness: { scope: :customer_id, message: "already has stock record for this customer" }

  def low_stock?
    quantity <= accessory.alert_when_stock_below
  end

  def adjust_stock!(change, adjustment_type:, notes: nil)
    transaction do
      new_quantity = quantity + change
      raise "Cannot reduce stock below zero" if new_quantity < 0

      update!(quantity: new_quantity)
      stock_adjustments.create!(
        quantity_change: change,
        adjustment_type: adjustment_type,
        notes: notes
      )
    end
  end
end
