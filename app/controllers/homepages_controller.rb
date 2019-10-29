class HomepagesController < ApplicationController
  def index
    @product = Product.highlight
  end
end
