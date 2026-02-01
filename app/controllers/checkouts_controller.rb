class CheckoutsController < ApplicationController
  before_action :set_customer

  def new
    @customer_stocks = @customer.customer_stocks.includes(accessory: { image_attachment: :blob }).where("quantity > 0")
    @checkout_items = []
  end

  def create
    checkout_items = params[:checkout_items] || []
    low_stock_items = []

    if checkout_items.empty?
      redirect_to new_customer_checkout_path(@customer), alert: "Please select items to checkout."
      return
    end

    ActiveRecord::Base.transaction do
      checkout_items.each do |item|
        customer_stock = @customer.customer_stocks.find(item[:customer_stock_id])
        quantity = item[:quantity].to_i

        raise "Invalid quantity" if quantity <= 0 || quantity > customer_stock.quantity

        customer_stock.adjust_stock!(-quantity, adjustment_type: "checkout", notes: "Checkout")

        if customer_stock.low_stock?
          low_stock_items << customer_stock
        end
      end
    end

    if low_stock_items.any?
      LowStockAlertJob.perform_later(@customer.id, low_stock_items.map(&:id))
    end

    redirect_to customer_customer_stocks_path(@customer), notice: "Checkout completed successfully!"
  rescue => e
    redirect_to new_customer_checkout_path(@customer), alert: "Checkout failed: #{e.message}"
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
