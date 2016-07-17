class Pastsale < ActiveRecord::Base
  belongs_to :owner
  belongs_to :sale
  enum transaction_side: { buyer: 0, seller: 1}
end
