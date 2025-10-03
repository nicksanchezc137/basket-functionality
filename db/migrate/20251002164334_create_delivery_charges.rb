class CreateDeliveryCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_charges do |t|
      t.references :product_catalogue, null: false, foreign_key: true
      t.decimal :lower_limit
      t.decimal :upper_limit
      t.decimal :delivery_cost

      t.timestamps
    end
  end
end
