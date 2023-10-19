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
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { error: "Can not search for name and price at the same time" }, status: 400
    else
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
        if params[:min_price].to_i < 0
          render json: { errors: {
            error: "Value can't be negative" 
          }}, status: 400
        else
          items = Item.min_price(params[:min_price])
          render json: ItemSerializer.new(items)
        end
      elsif params[:max_price].present?
        if params[:max_price].to_i < 0
          render json: { errors: {
            error: "Value can't be negative" 
          }}, status: 400
        else
          items = Item.max_price(params[:max_price])
          render json: ItemSerializer.new(items)
        end
      end
    end
  end

  def find
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { error: "Can not search for name and price at the same time" }, status: 400
    else
      if params[:name].present?
        item = Item.search_item(params[:name])
        if item != nil
          render json: ItemSerializer.new(item)
        else
          render json: { 
            data: {
            error: "Item does not exist"
            }
          }, status: 404
        end
      elsif params[:min_price].present?
        if params[:min_price].to_i < 0
          render json: { errors: {
            error: "Value can't be negative" 
          }}, status: 400
        else
          item = Item.min_price_single_item(params[:min_price])
          if item.nil?
            render json: { data: {
              error: "No Item was this expensive" 
            }}, status: 400
          else
            render json: ItemSerializer.new(item)
          end
        end
      elsif params[:max_price].present?
        if params[:max_price].to_i < 0
          render json: { errors: {
            error: "Value can't be negative" 
          }}, status: 400
        else
          item = Item.max_price_single_item(params[:max_price])
          if item.nil?
            render json: { data: {
              error: "No Item was this expensive" 
            }}, status: 400
          else
            render json: ItemSerializer.new(item)
          end
        end
      end
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end