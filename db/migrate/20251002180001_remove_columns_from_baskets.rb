class RemoveColumnsFromBaskets < ActiveRecord::Migration[7.0]
  def change
    remove_reference :baskets, :product_catalogue, foreign_key: true
    remove_column :baskets, :price, :decimal
  end
end
