require 'test_helper'

class OwnerTest < ActiveSupport::TestCase
  fixtures :houses, :owners

  def test_owner_can_have_houses
    cherry_lane = houses(:cherry_lane)
    kevin = owners(:kevin)
    russell = owners(:russell)

    assert cherry_lane

    assert_equal [kevin, russell], cherry_lane.owners
  end

  def test_house_has_current_owner
    kevin = owners(:kevin)
    cherry_lane = houses(:cherry_lane)

    assert_equal [kevin], cherry_lane.current_owners
  end

  def test_house_has_last_sellers
    russell = owners(:russell)
    cherry_lane = houses(:cherry_lane)

    assert_equal [russell], cherry_lane.last_sellers
  end
end
