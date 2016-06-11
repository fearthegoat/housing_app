class Sale < ActiveRecord::Base
  belongs_to :house
  has_many :owners
end
