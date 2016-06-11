class House < ActiveRecord::Base
  has_many :assessments
  has_many :sales
  has_many :owners, through: :pastowners
  has_many :pastowners

  belongs_to :guide
end
