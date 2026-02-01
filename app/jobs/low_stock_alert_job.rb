class LowStockAlertJob < ApplicationJob
  queue_as :default

  def perform(customer_id, customer_stock_ids)
    customer = Customer.find_by(id: customer_id)
    return unless customer

    low_stock_items = CustomerStock.includes(:accessory)
                                    .where(id: customer_stock_ids)
                                    .select(&:low_stock?)

    return if low_stock_items.empty?

    StockMailer.low_stock_alert(customer, low_stock_items).deliver_now
  end
end
