class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :description, limit: 255
      t.references :product_catalogue, null: false, foreign_key: true
      t.references :offer_product_catalogue, null: false, foreign_key: { to_table: :product_catalogues }
      t.decimal :offer_price

      t.timestamps
    end
  end
end
