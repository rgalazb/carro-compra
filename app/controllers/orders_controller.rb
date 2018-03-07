class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.cart
    @total = @orders.map {|order| order.product.price * order.quantity}.sum
    @cantidad = current_user.cart.inject(0) { |sum, order| sum += order.quantity }
  end

  def create
    @previous_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)
    if @previous_order.present?
      new_quantity = @previous_order.quantity + 1
      @previous_order.update(quantity: new_quantity)
      redirect_to root_path, notice: 'El producto se ha agregado al carrito'
    else
      @order = Order.new()
      @product = Product.find(params[:product_id])
      @order.product = @product
      @order.user = current_user
      @order.price = @product.price
      if @order.save
        redirect_to root_path, notice: 'El producto se ha agregado al carrito'
      else
        redirect_to root_path, alert: 'Error al agregar el producto'
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])

    if @order.quantity == 1
      @order.destroy
      redirect_to orders_path, notice: 'ha sido removido del carro'
    elsif @order.quantity > 1
      new_quantity = @order.quantity - 1
      @order.update(quantity: new_quantity)
      redirect_to orders_path, notice: 'carro actualizado'
    else
      redirect_to orders_path, alert: 'error'
    end
  end
  def empty_cart
    current_user.orders.destroy_all
    redirect_to orders_path, notice: 'se vacio el carro'
  end
end
