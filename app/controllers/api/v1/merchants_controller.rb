class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render json: { error: "Merchant does not exist" }, status: 404
    end
  end

  def create 
    render json: MerchantSerializer.new(Merchant.create(merchant_params))
  end

  def update 
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def find
    render json: MerchantSerializer.new(Merchant.search_merchant(params[:name]))
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
