#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
require File.dirname(__FILE__) + '/test_helper.rb'
 
class TestUriTemplate < Test::Unit::TestCase
  def test_encode
    assert_equal "stefan", UriTemplate::Encoder.encode("stefan")
    assert_equal '%26', UriTemplate::Encoder.encode("&")
  end
  
  def test_replace
    ut = UriTemplate::URI.new("http://example.org/{userid}")
    assert_equal "http://example.org/stefan", ut.replace("userid" => "stefan")
    assert_equal "http://example.org/paul%20auster", ut.replace("userid" => "paul auster")
  end

  def test_replace_types
    ut = UriTemplate::URI.new("http://example.org/{fixnum}/{bool}/{symbol}")
    assert_equal "http://example.org/1/true/sym", ut.replace("fixnum" => 1, "bool" => true, "symbol" => :sym)
  end
  
end
