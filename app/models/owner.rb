class Owner < ActiveRecord::Base
  has_many :houses, through: :pastowners
  has_many :pastowners, dependent: :destroy
  has_many :addresses, through: :pastaddresses
  has_many :pastaddresses, dependent: :destroy
  has_many :sales, through: :pastsales
  has_many :pastsales, dependent: :destroy
end
