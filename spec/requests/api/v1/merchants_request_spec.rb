require "rails_helper"

RSpec.describe "Merchants API" do
  it "gets all merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants_data = JSON.parse(response.body, symbolize_names: true)

    merchants = merchants_data[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id
  
    get "/api/v1/merchants/#{id}"
  
    merchant_data = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_data[:data]
  
    expect(response).to be_successful
  
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it "returns a 404 when id does not exist" do
    get "/api/v1/merchants/1"

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to have_http_status(404)
    expect(merchant).to have_key(:error)
    expect(merchant[:error]).to eq("Merchant does not exist")


  end

  it "can create a new merchant" do
    merchant_params = ({
                    name: "Elmer's Emporium"
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
    created_merchant = Merchant.last
  
    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Honey's Home" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})
    merchant = Merchant.find_by(id: id)
  
    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Honey's Home")
  end

  it "can search for a merchant" do
    create_list(:merchant, 20)
    
    get "/api/v1/merchants/find?name=e"

    expect(response).to be_successful

    merchants_data = JSON.parse(response.body, symbolize_names: true)

    merchant = merchants_data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it "returns an error when no name matches the search" do
    create(:merchant, name: "Blue")

    get "/api/v1/merchants/find?name=z"

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to have_http_status(404)
    expect(merchant[:data]).to have_key(:error)
    expect(merchant[:data][:error]).to eq("Merchant does not exist")
  end
end

