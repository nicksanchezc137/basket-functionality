class CreateProductCatalogues < ActiveRecord::Migration[7.0]
  def change
    create_table :product_catalogues do |t|
      t.string :product_name, limit: 255
      t.string :code, limit: 255
      t.decimal :price, precision: 10, scale: 2
      t.string :image_url, limit: 255

      t.timestamps
    end
  end
end
