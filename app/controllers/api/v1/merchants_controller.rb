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
    specific_merchant = Merchant.search_merchant(params[:name])
    if specific_merchant != nil
      render json: MerchantSerializer.new(specific_merchant)
    else
      render json: { 
        data: {
        error: "Merchant does not exist"
        }
      }, status: 404
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
