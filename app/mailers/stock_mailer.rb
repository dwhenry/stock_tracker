class StockMailer < ApplicationMailer
  def low_stock_alert(customer, low_stock_items)
    @customer = customer
    @low_stock_items = low_stock_items

    mail(
      to: @customer.email,
      subject: "Low Stock Alert - Action Required"
    )
  end
end
