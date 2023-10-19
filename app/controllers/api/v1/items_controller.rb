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
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: { error: "Item does not exist" }, status: 404
    end
  end

  def create 
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def update 
    if Item.find(params[:id]) && (!params[:merchant_id] || Merchant.find(params[:merchant_id]))
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render json: { error: "Merchant does not exist" }, status: 404
    end
  end

  def find_all
    if params[:name].present?
      items = Item.search_items(params[:name])
      if items != nil
        render json: ItemSerializer.new(items)
      else
        render json: { 
          data: {
          error: "Item does not exist"
          }
        }, status: 404
      end
    elsif params[:min_price].present?
      items = Item.min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end