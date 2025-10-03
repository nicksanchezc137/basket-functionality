class CreateBaskets < ActiveRecord::Migration[7.0]
  def change
    create_table :baskets do |t|
      t.references :product_catalogue, null: false, foreign_key: true
      t.decimal :price, null: false
      t.references :offer, null: true, foreign_key: true

      t.timestamps
    end
  end
end
