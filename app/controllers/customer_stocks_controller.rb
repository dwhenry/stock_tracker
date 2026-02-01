class CustomerStocksController < ApplicationController
  before_action :set_customer
  before_action :set_customer_stock, only: %i[show edit update destroy]

  def index
    @customer_stocks = @customer.customer_stocks.includes(:accessory).order("accessories.name")
  end

  def show
    @adjustments = @customer_stock.stock_adjustments.recent
  end

  def new
    @customer_stock = @customer.customer_stocks.build
    @available_accessories = Accessory.where.not(id: @customer.accessory_ids)
  end

  def edit
  end

  def create
    @customer_stock = @customer.customer_stocks.build(customer_stock_params)

    if @customer_stock.save
      @customer_stock.stock_adjustments.create!(
        quantity_change: @customer_stock.quantity,
        adjustment_type: "initial",
        notes: "Initial stock setup"
      )
      redirect_to customer_customer_stocks_path(@customer), notice: "Stock was successfully added."
    else
      @available_accessories = Accessory.where.not(id: @customer.accessory_ids)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    old_quantity = @customer_stock.quantity
    if @customer_stock.update(customer_stock_params)
      change = @customer_stock.quantity - old_quantity
      if change != 0
        @customer_stock.stock_adjustments.create!(
          quantity_change: change,
          adjustment_type: change > 0 ? "addition" : "removal",
          notes: "Manual stock adjustment"
        )
      end
      redirect_to customer_customer_stocks_path(@customer), notice: "Stock was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer_stock.destroy
    redirect_to customer_customer_stocks_path(@customer), notice: "Stock record was successfully deleted."
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_customer_stock
    @customer_stock = @customer.customer_stocks.find(params[:id])
  end

  def customer_stock_params
    params.require(:customer_stock).permit(:accessory_id, :quantity)
  end
end
