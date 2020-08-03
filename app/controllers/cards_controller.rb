class CardsController < ApplicationController

  before_action :authenticate
  before_action :set_current_user
  after_action :log_request

  def index
    @cards = Card.all.includes(:payments)
    render json: @cards
  end

  def show
    @card = Card.find(params[:id])
    render json: @card
  end

  def payments
    @payments = Card.find(params[:id]).payments
    render json: @payments
  end

  def create
    @card = Card.new(card_params)

    if @card.save
      render json: @card
    else
      render json: { message: 'Validation failed.', errors: @card.errors }, status: :unprocessable_entity
    end
  end


  def update
    @card = Card.find(params[:id])

    if @card.update_attributes(card_params)
      render json: @card
    else
      render json: { message: 'Validation failed.', errors: @card.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @card = Card.find(params[:id])
    if @card.destroy
      render json: { deleted: true, id: @card.uid }
    end
  end

  private

  def card_params
    params.permit(:number,:brand, :exp_month, :exp_year, :limit, :name, :cvv)
  end
end

