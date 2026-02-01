class CreateStockAdjustments < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_adjustments do |t|
      t.references :customer_stock, null: false, foreign_key: true
      t.integer :quantity_change
      t.string :adjustment_type
      t.text :notes

      t.timestamps
    end
  end
end
