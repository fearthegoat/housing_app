class House < ActiveRecord::Base
  has_many :assessments, dependent: :destroy
  has_many :sales, -> {order('date DESC')}#change to sold_on
  has_many :pastsales, through: :sales
  has_many :owners, through: :pastsales

  def address=(string)
    # self[:address] = string
    self[:street] = string.gsub(/^((\d[a-zA-Z])|[^a-zA-Z])*/, '')
    matches = string.match(/^(?<number>\S*)\s+(?<name>.*)\s+(?<type>.*)$/)
    if matches
      self[:number] = matches[:number]
      self[:street_type] = matches[:type]
    else
      Rails.logger.warn("BLEW UP #{attributes} #{string}")
    end
  end

  def current_owners
    sales.first.buyers
  end


  def last_sellers
    sales.first.sellers
  end

end
