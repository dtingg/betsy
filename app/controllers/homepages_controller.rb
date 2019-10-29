class HomepagesController < ApplicationController
  def index
    @products = Product.highlight
  end
end
