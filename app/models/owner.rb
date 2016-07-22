class Owner < ActiveRecord::Base
  # Addresses
  has_many :pastaddresses, dependent: :destroy
  has_many :addresses, through: :pastaddresses

  # Sales
  has_many :pastsales, dependent: :destroy
  has_many :sales, through: :pastsales
  has_many :houses, through: :sales

  def current_address
    pastaddresses.first.address
  end
end
