require "rails_helper"

RSpec.describe "Items API" do
  it "gets all items through a single merchant" do
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

  it "returns a 404 when merchant id does not exist when looking at a merchant's items" do
    get "/api/v1/merchants/1/items"

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to have_http_status(404)
    expect(merchant).to have_key(:error)
    expect(merchant[:error]).to eq("Merchant does not exist")
  end

  it "gets all items" do
    merchant = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)
    item_3 = create(:item, merchant_id: merchant.id)
    item_4 = create(:item, merchant_id: merchant_2.id)

    get "/api/v1/items"
    
    expect(response).to be_successful

    items_data = JSON.parse(response.body, symbolize_names: true)

    items = items_data[:data]

    expect(items.count).to eq(4)

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

  it "can get one item by its id" do
    merchant = create(:merchant)
    
    id = create(:item, merchant_id: merchant.id).id
  
    get "/api/v1/items/#{id}"
  
    item_data = JSON.parse(response.body, symbolize_names: true)
    item = item_data[:data]
  
    expect(response).to be_successful
  
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:attributes)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes][:merchant_id]).to be_a(Integer)
  end

  it "returns a 404 when id does not exist or is not in proper format" do
    get "/api/v1/items/1"

    item = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to have_http_status(404)
    expect(item).to have_key(:error)
    expect(item[:error]).to eq("Item does not exist")
  end

  it "can create an item" do
    merchant = create(:merchant)

    item_params = ({
                    name: "Hat",
                    description: "Comfy",
                    unit_price: 12.50,
                    merchant_id: merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
  
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can update an existing item" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    previous_name = Item.last.name
    item_params = { name: "Sombrero Rojo" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Sombrero Rojo")
  end
end