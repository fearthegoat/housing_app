class House < ActiveRecord::Base
  has_many :assessments
  has_many :sales
end
