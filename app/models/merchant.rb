class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  validates :name, presence: true

  def self.search_merchant(search_params)
      where("name ILIKE ?", "%#{search_params.downcase}%").first 
  end
end