class Pastowner < ActiveRecord::Base
  belongs_to :owner
  belongs_to :house
end
