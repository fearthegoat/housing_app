require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  def test_returns_current_address
    main_street = addresses(:main_street)
    kevin = owners(:kevin)

    assert_equal [main_street], kevin.current_address
  end

  # test "the truth" do
  #   assert true
  # end
end
