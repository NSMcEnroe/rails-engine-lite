class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id].present?
      if Merchant.exists?(params[:merchant_id])
        render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
      else
        render json: { error: "Merchant does not exist" }, status: 404
      end
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end