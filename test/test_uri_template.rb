#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
require File.dirname(__FILE__) + '/test_helper.rb'
 
class TestUriTemplate < Test::Unit::TestCase
  def test_encode
    assert_equal "stefan", UriTemplate::Encoder.encode("stefan")
    assert_equal '%26', UriTemplate::Encoder.encode("&")
    assert_equal '%20', UriTemplate::Encoder.encode(" ")
    #assert_equal '%CE%8E', UriTemplate::Encoder.encode(Unicode::U03d3)
  end
  
  def test_op
    defaults = {
      'a' => 'foo',
      'b' => 'bar',
      'data' => "10,20,30",
      'points' => ["10","20","30"],
      'list0' => [],
      'str0' => '',
      'reserved' => ':/?#[]@!$&\'()*+,;=',
      'u' => '♔♕',
      'a_b' => 'baz'
    }
    assert_equal '/&wilma/#bar', UriTemplate::URI.new('/{-prefix|&|foo=wilma}/{-prefix|#|b}').replace(defaults)
    assert_equal '/foo/data#bar', UriTemplate::URI.new('/{-suffix|/|a}{-opt|data|points}{-neg|@|a}{-prefix|#|b}').replace(defaults)
  end
  
  def test_replace
    ut = UriTemplate::URI.new("http://example.org/{userid}")
    assert_equal "http://example.org/stefan", ut.replace("userid" => "stefan")
    assert_equal "http://example.org/paul%20auster", ut.replace("userid" => "paul auster")
  end

  def test_replace_types
    ut = UriTemplate::URI.new("http://example.org/{fixnum}/{bool}/{symbol}")
    assert_equal "http://example.org/1/true/sym", ut.replace("fixnum" => 1, "bool" => true, "symbol" => :sym)
    assert_equal "http://example.org/1/false/sym", ut.replace("fixnum" => 1, "bool" => false, "symbol" => :sym)
  end
  
end
