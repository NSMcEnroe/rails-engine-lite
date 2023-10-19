class Api::V1::ItemMerchantsController < ApplicationController
  def show
    specific_merchant = Item.find(params[:id])[:merchant_id]
    render json: MerchantSerializer.new(Merchant.find(specific_merchant))
  end
end