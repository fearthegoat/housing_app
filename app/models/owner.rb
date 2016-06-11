class Owner < ActiveRecord::Base
  has_many :houses, through: :pastowners
  has_many :pastowners
  has_many :addresses
end
