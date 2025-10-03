class HomeController < ApplicationController
  def index
    @product_catalogues = ProductCatalogue.all
  end

  def about
  end
end
