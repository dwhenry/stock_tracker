class AccessoriesController < ApplicationController
  before_action :set_accessory, only: %i[show edit update destroy]

  def index
    @accessories = Accessory.all.order(:name)
  end

  def show
  end

  def new
    @accessory = Accessory.new
  end

  def edit
  end

  def create
    @accessory = Accessory.new(accessory_params)

    if @accessory.save
      redirect_to accessories_path, notice: "Accessory was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @accessory.update(accessory_params)
      redirect_to accessories_path, notice: "Accessory was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @accessory.destroy
    redirect_to accessories_path, notice: "Accessory was successfully deleted."
  end

  private

  def set_accessory
    @accessory = Accessory.find(params[:id])
  end

  def accessory_params
    params.require(:accessory).permit(:name, :alert_when_stock_below, :barcode, :image)
  end
end
