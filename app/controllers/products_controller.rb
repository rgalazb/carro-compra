class ProductsController < ApplicationController
  def index
    @products = Product.all
    if current_user.present?
      @cantidad = current_user.orders.inject(0) {|sumar, order| sumar += order.quantity }
    end
  end
end
