require "rails_helper"

RSpec.describe "Items API" do
  it "gets all items" do
    id = create(:merchant).id

    item_1 = create(:item, merchant_id: id)
    item_2 = create(:item, merchant_id: id)
    item_3 = create(:item, merchant_id: id)

    get "/api/v1/merchants/#{id}/items"
    
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
    end
  end
end