class BasketsController < ApplicationController
  before_action :set_basket, only: [:show, :edit, :update, :destroy]

  def index
    @basket = Basket.first
    if @basket
      @basket_line_items = @basket.basket_line_items.includes(:product_catalogue)
      @basket_total = @basket.total_price
      @delivery_charge = calculate_delivery_charge(@basket_total)
      @final_total = @basket_total + @delivery_charge
    else
      @basket_line_items = []
      @basket_total = 0
      @delivery_charge = 0
      @final_total = 0
    end
  end

  def show
  end

  def new
    @basket = Basket.new
    @product_catalogues = ProductCatalogue.all
    @offers = Offer.all
  end

  def edit
    @product_catalogues = ProductCatalogue.all
    @offers = Offer.all
  end

  def create
    @basket = Basket.new(basket_params)

    if @basket.save
      redirect_to @basket, notice: 'Basket item was successfully created.'
    else
      @product_catalogues = ProductCatalogue.all
      @offers = Offer.all
      render :new
    end
  end

  def update
    if @basket.update(basket_params)
      redirect_to @basket, notice: 'Basket item was successfully updated.'
    else
      @product_catalogues = ProductCatalogue.all
      @offers = Offer.all
      render :edit
    end
  end

  def destroy
    @basket.destroy
    redirect_to baskets_url, notice: 'Basket deleted successfully.'
  end

  def add
    product = ProductCatalogue.find_by(code: params[:product_code])
    
    if product
      basket = Basket.first || Basket.create!
      
      basket_line_item = basket.basket_line_items.create!(
        product_catalogue: product,
        price: product.price
      )
      
      check_and_apply_offers(basket, product)
      
      redirect_to baskets_path, notice: "#{product.product_name} added to basket for $#{sprintf("%.2f", product.price)}"
    else
      redirect_to product_catalogues_path, alert: "Product not found with code: #{params[:product_code]}"
    end
  end

  private

  def set_basket
    @basket = Basket.find(params[:id])
  end

  def basket_params
    params.require(:basket).permit(:product_catalogue_id, :price, :offer_id)
  end

  def calculate_delivery_charge(total)
    return 0 if total <= 0
    
    delivery_charge = DeliveryCharge.where('lower_limit <= ? AND upper_limit >= ?', total, total).first
    
    if delivery_charge
      delivery_charge.delivery_cost
    else
      DeliveryCharge.where('lower_limit <= ?', total).order(:lower_limit).last&.delivery_cost || 0
    end
  end

  def check_and_apply_offers(basket, product)
    offers = product.offers
    
    offers.each do |offer|
      product_count = basket.basket_line_items.where(product_catalogue: product).count
      
      if product_count >= offer.trigger_count
        unless basket.basket_line_items.exists?(offer: offer)
          basket.basket_line_items.create!(
            product_catalogue: offer.offer_product_catalogue,
            price: offer.offer_price,
            offer: offer
          )
        end
      end
    end
  end
end
