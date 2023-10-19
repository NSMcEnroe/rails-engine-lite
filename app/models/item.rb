class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.search_items(search_params)
    where("name ILIKE ?", "%#{search_params.downcase}%")
  end

  def self.min_price(price)
    where("unit_price >= ?", price)
  end

  def self.max_price(price)
    where("unit_price <= ?", price)
  end
end
