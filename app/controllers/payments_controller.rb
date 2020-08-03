class PaymentsController < ApplicationController

  before_action :authenticate
  before_action :set_current_user
  after_action :log_request

  def index
    @payments = Payment.all
    render json: @payments
  end

  def show
    @payment = Payment.find(params[:id])
    render json: @payment
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      render json: @payment
    else
      render json: { message: 'Validation failed.', errors: @payment.errors }, status: :unprocessable_entity
    end
  end


  def update
    @payment = Payment.find(params[:id])

    if @payment.update_attributes(payment_params)
      render json: @payment
    else
      render json: { message: 'Validation failed.', errors: @payment.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    if @payment.destroy
      render json: { deleted: true, id: @payment.uid }
    end
  end

  private

  def payment_params
    params.permit(:amount, :status, :card_id)
  end
end
