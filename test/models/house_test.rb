require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  def test_setting_address_on_house_will_assign_street_number

    house = House.new
    house.address = "123 Cherry Lane"
    assert_equal 123, house.number
  end

  def test_setting_address_on_house_will_assign_street_number_when_not_present

    house = House.new
    house.address = "Cherry Lane"
    assert_equal nil, house.number
  end
end
