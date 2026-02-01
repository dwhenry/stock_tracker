class CreateAccessories < ActiveRecord::Migration[8.1]
  def change
    create_table :accessories do |t|
      t.string :name
      t.integer :alert_when_stock_below
      t.string :barcode

      t.timestamps
    end
  end
end
