class DeliveryChargesController < ApplicationController
  before_action :set_delivery_charge, only: [:show, :edit, :update, :destroy]
  before_action :set_product_catalogue, only: [:new, :create]

  # GET /delivery_charges
  def index
    @delivery_charges = DeliveryCharge.includes(:product_catalogue).all
  end

  # GET /delivery_charges/1
  def show
  end

  # GET /delivery_charges/new
  def new
    @delivery_charge = @product_catalogue.delivery_charges.build
  end

  # GET /delivery_charges/1/edit
  def edit
  end

  # POST /delivery_charges
  def create
    @delivery_charge = @product_catalogue.delivery_charges.build(delivery_charge_params)

    if @delivery_charge.save
      redirect_to @delivery_charge, notice: 'Delivery charge was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /delivery_charges/1
  def update
    if @delivery_charge.update(delivery_charge_params)
      redirect_to @delivery_charge, notice: 'Delivery charge was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /delivery_charges/1
  def destroy
    @delivery_charge.destroy
    redirect_to delivery_charges_url, notice: 'Delivery charge was successfully destroyed.'
  end

  private

  def set_delivery_charge
    @delivery_charge = DeliveryCharge.find(params[:id])
  end

  def set_product_catalogue
    @product_catalogue = ProductCatalogue.find(params[:product_catalogue_id]) if params[:product_catalogue_id]
  end

  def delivery_charge_params
    params.require(:delivery_charge).permit(:product_catalogue_id, :lower_limit, :upper_limit, :delivery_cost)
  end
end
