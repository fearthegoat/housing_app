class House < ActiveRecord::Base
  has_many :assessments, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :owners, through: :pastowners
  has_many :pastowners
end
