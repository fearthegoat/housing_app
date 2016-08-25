require 'test_helper'

class FfxParserTest < ActiveSupport::TestCase

  def test_can_parse
    html = "../ffx-records-data/0022030011.html"
    results = FfxParser.new(File.open(html)).parse

    assert_equal Hash, results.class
  end

  def test_correctly_identifies_owners
  	html = "/ffx-records-data/0022030011.html"
  	results = FfxParser.new(File.open(html)).parse

  	assert_equal ['MOSTAGHIM HOUTAN','MOSTAGHIM NICA'], house[:owner]
  end


end
