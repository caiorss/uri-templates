require File.dirname(__FILE__) + '/test_helper.rb'
 

 
class TestUriTemplateGrammar < Test::Unit::TestCase
  
  def setup
    @parser = UriTemplateParser.new
  end
  
  def test_simple
    assert_equal "http", @parser.parse('http').value
    assert_not_nil @parser.parse('http')
    assert_not_nil @parser.parse('http{foo}').value({"foo" => "stefan"})
    assert_not_nil @parser.parse('http://{foo}')
    assert_not_nil @parser.parse('http://example.org/news/{id}/')
    assert_not_nil @parser.parse('http://www.google.com/notebook/feeds/{userID}')
    assert_not_nil @parser.parse('http://www.google.com/notebook/feeds/{-prefix|/notebooks/|notebookID}')
    assert_not_nil @parser.parse('http://www.google.com/notebook/feeds/{userID}{-prefix|/notebooks/|notebookID}')
    assert_not_nil @parser.parse('http://www.google.com/notebook/feeds/{userID}{-prefix|/notebooks/|notebookID}{-opt|/-/|categories}{-listjoin|/|categories}?{-join|&|updated-min,updated-max,alt,start-index,max-results,entryID,orderby}')
    #puts @parser.parse('http://www.google.com/notebook/feeds/{userID}{-prefix|/notebooks/|notebookID}{-opt|/-/|categories}{-listjoin|/|categories}?{-join|&|updated-min,updated-max,alt,start-index,max-results,entryID,orderby}').inspect
  end
  
  def test_replace
    assert_equal "stefan", @parser.parse('{foo}').value({"foo" => "stefan"})
    #assert_equal "stefansaasen", @parser.parse('{foo}saasen').value({"foo" => "stefan"})
    #assert_equal "httpstefan", @parser.parse('http{foo}').value({"foo" => "stefan"})
  end
  
end
