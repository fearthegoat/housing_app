class Pastaddress < ActiveRecord::Base
  belongs_to :owner
  belongs_to :address
end
