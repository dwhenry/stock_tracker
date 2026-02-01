class DashboardController < ApplicationController
  def index
    @customers_count = Customer.count
    @accessories_count = Accessory.count
    @low_stock_items = CustomerStock.includes(:customer, :accessory)
                                     .joins(:accessory)
                                     .where("customer_stocks.quantity <= accessories.alert_when_stock_below")
                                     .order("customer_stocks.quantity ASC")
                                     .limit(10)
  end
end
