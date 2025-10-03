class CreateBasketLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :basket_line_items do |t|
      t.references :basket, null: false, foreign_key: true
      t.references :product_catalogue, null: false, foreign_key: true
      t.decimal :price, null: false

      t.timestamps
    end
  end
end
