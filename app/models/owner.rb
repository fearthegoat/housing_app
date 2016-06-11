class Owner < ActiveRecord::Base
  has_many :houses, through: :pastowners
  has_many :pastowners
  has_many :addresses
  has_many :sales, through: :pastsales
  has_many :pastsales
end
