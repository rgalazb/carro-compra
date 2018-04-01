class ProductsController < ApplicationController
  def index
    if params[:buscar].present?
      @products = Product.where('name like ?', "%#{params[:buscar]}%")
      respond_to do |format|
        format.js
      end
    else
      @products = Product.all
      if current_user.present?
        @cantidad = current_user.cart.inject(0) { |sum, order| sum += order.quantity }
      end
    end
  end
end
