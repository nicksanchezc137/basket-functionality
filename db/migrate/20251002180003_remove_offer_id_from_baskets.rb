class RemoveOfferIdFromBaskets < ActiveRecord::Migration[7.0]
  def change
    remove_reference :baskets, :offer, foreign_key: true
  end
end
