class ProductCataloguesController < ApplicationController
  before_action :set_product_catalogue, only: [:show, :edit, :update, :destroy]

  # GET /product_catalogues
  def index
    @product_catalogues = ProductCatalogue.all
  end

  # GET /product_catalogues/1
  def show
  end

  # GET /product_catalogues/new
  def new
    @product_catalogue = ProductCatalogue.new
  end

  # GET /product_catalogues/1/edit
  def edit
  end

  # POST /product_catalogues
  def create
    @product_catalogue = ProductCatalogue.new(product_catalogue_params)

    if @product_catalogue.save
      redirect_to @product_catalogue, notice: 'Product catalogue was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_catalogues/1
  def update
    if @product_catalogue.update(product_catalogue_params)
      redirect_to @product_catalogue, notice: 'Product catalogue was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /product_catalogues/1
  def destroy
    @product_catalogue.destroy
    redirect_to product_catalogues_url, notice: 'Product catalogue was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_catalogue
    @product_catalogue = ProductCatalogue.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_catalogue_params
    params.require(:product_catalogue).permit(:product_name, :code, :price, :image_url)
  end
end
