require "rails_helper"

RSpec.describe "Items API" do
  it "gets all items" do
    merchant = create(:merchant)

    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)
    item_3 = create(:item, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"
    
    expect(response).to be_successful

    items_data = JSON.parse(response.body, symbolize_names: true)

    items = items_data[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it "returns a 404 when merchant id does not exist" do
    get "/api/v1/merchants/1/items"

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to have_http_status(404)
    expect(merchant).to have_key(:error)
    expect(merchant[:error]).to eq("Merchant does not exist")
  end
end