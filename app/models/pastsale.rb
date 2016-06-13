class Pastsale < ActiveRecord::Base
  belongs_to :owner
  belongs_to :sale
end
