class AddOfferIdToBasketLineItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :basket_line_items, :offer, null: true, foreign_key: true
  end
end
