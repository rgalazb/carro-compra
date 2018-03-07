class ProductsController < ApplicationController
  def index
    @products = Product.all
    if current_user.present?
      @cantidad = current_user.cart.inject(0) { |sum, order| sum += order.quantity }
    end
  end
end
