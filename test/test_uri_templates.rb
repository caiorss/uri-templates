require File.dirname(__FILE__) + '/test_helper.rb'
 
class TcUriTemplateTest < Test::Unit::TestCase
  
  def test_simple
    parser = AviarcParser.new
    lines = parser.parse '{foo}'
    puts lines.replace!
  end
  
end
