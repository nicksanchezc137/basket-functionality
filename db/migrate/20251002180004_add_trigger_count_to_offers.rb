class AddTriggerCountToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :trigger_count, :integer, null: false, default: 1
  end
end
