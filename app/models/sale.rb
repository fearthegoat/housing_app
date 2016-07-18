class Sale < ActiveRecord::Base
  belongs_to :house

  has_many :owners, through: :pastsales
  has_many :pastsales, dependent: :destroy

  def buyers
    owners.joins(:pastsales).where("pastsales.transaction_side" => 'buyer')
  end

  def sellers
    owners.joins(:pastsales).where("pastsales.transaction_side" => 'seller')
  end

  def seller=(string)
    owner = Owner.where(name: string).first_or_create
    pastsales.build(owner: owner, transaction_side: :seller)
  end

  def buyer=(string)
    owner = Owner.where(name: string).first_or_create
    pastsales.build(owner: owner, transaction_side: :buyer)
  end

end
