class BasketLineItemsController < ApplicationController
  before_action :set_basket_line_item, only: [:destroy]

  def destroy
    basket = @basket_line_item.basket
    product = @basket_line_item.product_catalogue
    
    check_and_remove_offers(basket, product)
    
    @basket_line_item.destroy
    
    redirect_to baskets_path, notice: 'Basket line item was successfully removed.'
  end

  private

  def set_basket_line_item
    @basket_line_item = BasketLineItem.find(params[:id])
  end

  def basket_line_item_params
    params.require(:basket_line_item).permit(:basket_id, :product_catalogue_id, :price, :offer_id)
  end

  def check_and_remove_offers(basket, product)
    offers = product.offers
    
    offers.each do |offer|
      current_count = basket.basket_line_items
                           .where(product_catalogue: product)
                           .where.not(id: @basket_line_item.id)
                           .where(offer: nil)
                           .count
      
      if current_count < offer.trigger_count
        offer_line_item = basket.basket_line_items.find_by(offer: offer)
        offer_line_item&.destroy
      end
    end
  end
end
