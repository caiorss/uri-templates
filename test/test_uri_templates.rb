require File.dirname(__FILE__) + '/test_helper.rb'
 
class TestUriTemplate < Test::Unit::TestCase
  def test_encode
    assert_equal "stefan", UriTemplate::Encoder.encode("stefan")
    assert_equal '%26', UriTemplate::Encoder.encode("&")
  end
end
