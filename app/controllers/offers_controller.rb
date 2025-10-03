class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy]
  before_action :set_product_catalogue, only: [:new, :create]

  # GET /offers
  def index
    @offers = Offer.includes(:product_catalogue, :offer_product_catalogue).all
  end

  # GET /offers/1
  def show
  end

  # GET /offers/new
  def new
    @offer = @product_catalogue.offers.build
    @product_catalogues = ProductCatalogue.all
  end

  # GET /offers/1/edit
  def edit
    @product_catalogues = ProductCatalogue.all
  end

  # POST /offers
  def create
    @offer = @product_catalogue.offers.build(offer_params)

    if @offer.save
      redirect_to @offer, notice: 'Offer was successfully created.'
    else
      @product_catalogues = ProductCatalogue.all
      render :new
    end
  end

  # PATCH/PUT /offers/1
  def update
    if @offer.update(offer_params)
      redirect_to @offer, notice: 'Offer was successfully updated.'
    else
      @product_catalogues = ProductCatalogue.all
      render :edit
    end
  end

  # DELETE /offers/1
  def destroy
    @offer.destroy
    redirect_to offers_url, notice: 'Offer was successfully destroyed.'
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def set_product_catalogue
    @product_catalogue = ProductCatalogue.find(params[:product_catalogue_id]) if params[:product_catalogue_id]
  end

  def offer_params
    params.require(:offer).permit(:product_catalogue_id, :offer_product_catalogue_id, :description, :offer_price)
  end
end
