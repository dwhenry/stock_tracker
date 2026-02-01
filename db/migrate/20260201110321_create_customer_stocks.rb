class CreateCustomerStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :customer_stocks do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :accessory, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
