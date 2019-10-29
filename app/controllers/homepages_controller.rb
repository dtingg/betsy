class HomepagesController < ApplicationController
  def index
    @top_products = Product.all.highlight
  end
end
