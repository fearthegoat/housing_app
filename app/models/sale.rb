class Sale < ActiveRecord::Base
  belongs_to :house
  has_many :owners, through: :pastsales
  has_many :pastsales, dependent: :destroy
end
