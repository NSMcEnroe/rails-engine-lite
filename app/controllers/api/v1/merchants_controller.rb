class Api::V1::MerchantController < ApplicationController
  def index
    render json: Merchant.all
  end
end