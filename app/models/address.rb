class Address < ActiveRecord::Base
    has_many :owners, through: :pastaddresses
    has_many :pastaddresses, -> {order('date_of_information DESC')}
end
