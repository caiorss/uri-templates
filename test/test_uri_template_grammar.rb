require File.dirname(__FILE__) + '/test_helper.rb'
 
class TestUriTemplateGrammar < Test::Unit::TestCase
  
  def check(expected, template, values = {})
    assert_equal expected, @parser.parse('{' + template + '}').value(values)      
  end
  
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
    assert_equal "stefansaasen", @parser.parse('{foo}saasen').value({"foo" => "stefan"})
    assert_equal "httpstefan", @parser.parse('http{foo}').value({"foo" => "stefan"})
    
    check "", "foo"
    check "barney", "foo", "foo" => "barney"
    check "barney", "foo", "foo" => "barney"
    check "wilma", "foo=wilma"
    check "barney", "foo=wilma", "foo" => "barney"
  end
  
  def test_append
    check "", "-append|/|foo"
    check "wilma#", "-append|#|foo=wilma"
    check "barney&?", "-append|&?|foo=wilma", "foo" =>  "barney"
  end
  
  def test_listjoin
    check "", "-listjoin|/|foo"
    check "a/b", "-listjoin|/|foo", "foo" => ['a', 'b']
    check "ab", "-listjoin||foo", "foo" => ['a', 'b']
    check "a", "-listjoin|/|foo", "foo" => ['a']
    check "", "-listjoin|/|foo", "foo" => []
  end
  
  def test_join
    check "", "-join|/|foo"
    check "", "-join|/|foo,bar"
    check "", "-join|&|q,num"
    check "foo=wilma", "-join|#|foo=wilma"
    check "foo=wilma", "-join|#|foo=wilma,bar"
    # The following test (taken from the python implementation) seems to be wrong?
    #check "bar=barney#foo=wilma", "-join|#|foo=wilma,bar=barney"
    check "foo=wilma#bar=barney", "-join|#|foo=wilma,bar=barney"
    check "foo=barney", "-join|&?|foo=wilma", "foo" =>  "barney"
  end

  def test_prefix
    check "", "-prefix|&|foo"
    check "&wilma", "-prefix|&|foo=wilma"
    check "wilma", "-prefix||foo=wilma"
    check "&barney", "-prefix|&|foo=wilma", "foo" =>  "barney"        
  end

  def test_opt
    check "", "-opt|&|foo"
    check "&", "-opt|&|foo", "foo" => "fred"
    check "", "-opt|&|foo", "foo" => []
    check "&", "-opt|&|foo", "foo" => ["a"]
    check "&", "-opt|&|foo,bar", "foo" => ["a"]
    check "&", "-opt|&|foo,bar", "bar" => "a"
    check "", "-opt|&|foo,bar"
  end

  def test_neg
    check "&", "-neg|&|foo"
    check "", "-neg|&|foo", "foo" => "fred"
    check "&", "-neg|&|foo", "foo" => []
    check "", "-neg|&|foo", "foo" => ["a"]
    check "", "-neg|&|foo,bar", "bar" => "a"
    check "&", "-neg|&|foo,bar", "bar" => []
  end
  
  def test_ws
    #check "%20", "foo", "foo" => ' '
    #check "%26&%26&%7C&_", "-listjoin|&|foo", "foo" => ["&", "&", "|", "_"]
  end
  
  def test_misc
    assert_equal "http://www.google.com/notebook/feeds/joe?",  @parser.parse("http://www.google.com/notebook/feeds/{userID}{-prefix|/notebooks/|notebookID}{-opt|/-/|categories}{-listjoin|/|categories}?{-join|&|updated-min,updated-max,alt,start-index,max-results,entryID,orderby}").value("userID" => "joe")
    assert_equal "http://example.org/news/joe/", @parser.parse("http://example.org/news/{id}/").value("id" => "joe")
  end
  
  #                   +----------+--------------------+
  #                   | Name     | Value              |
  #                   +----------+--------------------+
  #                   | a        | foo                |
  #                   | b        | bar                |
  #                   | data     | 10,20,30           |
  #                   | points   | ["10","20", "30"]  |
  #                   | list0    | []                 |
  #                   | str0     |                    |
  #                   | reserved | :/?#[]@!$&'()*+,;= |
  #                   | u        | \u2654\u2655       |
  #                   | a_b      | baz                |
  #                   +----------+--------------------+
  # The name 'foo' has not been defined, the value of 'str0' is the empty
  # string, and both list0 and points are lists.  The variable 'u' is a
  # string of two unicode characters, the WHITE CHESS KING (0x2654) and
  # the WHITE CHESS QUEEN (0x2655).
  def test_draft
    defaults = {
      'a' => 'foo',
      'b' => 'bar',
      'data' => "10,20,30",
      'points' => ["10","20","30"],
      'list0' => [],
      'str0' => '',
      'reserved' => ':/?#[]@!$&\'()*+,;=',
      'u' => '\u2654\u2655',
      'a_b' => 'baz'
    }
    assert_equal 'http://example.org/?q=foo', @parser.parse('http://example.org/?q={a}').value(defaults)
    assert_equal 'http://example.org/', @parser.parse('http://example.org/{foo}').value(defaults)
    
    # reserved
    assert_equal 'relative/%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D/', @parser.parse('relative/{reserved}/').value(defaults)
    # default value
    assert_equal 'http://example.org/fred', @parser.parse('http://example.org/{foo=fred}').value(defaults)
    assert_equal 'http://example.org/%25/', @parser.parse('http://example.org/{foo=%25}/').value(defaults)
 
    # prefix op 
    assert_equal '/', @parser.parse('/{-prefix|#|foo}').value(defaults)
    assert_equal './#bar', @parser.parse('./{-prefix|#|b}').value(defaults)
    assert_equal './', @parser.parse('./{-prefix|#|str0}').value(defaults)
    
    # append, prefix
    assert_equal '/foo/#bar', @parser.parse('/{-append|/|a}{-prefix|#|b}').value(defaults)
    
    # neg
    assert_equal '/', @parser.parse('/{-neg|@|a}').value(defaults)
    
    # append, opt, neg, prefix
    assert_equal '/foo/data#bar', @parser.parse('/{-append|/|a}{-opt|data|points}{-neg|@|a}{-prefix|#|b}').value(defaults)
    
    # UTF-8
    # assert_equal 'http://example.org/q=%E2%99%94%E2%99%95', @parser.parse('http://example.org/q={u}/').value(defaults)
    
    # join
    assert_equal 'http://example.org/?a=foo&data=10%2C20%2C30', @parser.parse('http://example.org/?{-join|&|a,data}').value(defaults)
    
    # listjoin
    assert_equal 'http://example.org/?d=10,20,30&a=foo&b=bar', @parser.parse('http://example.org/?d={-listjoin|,|points}&{-join|&|a,b}').value(defaults)    
    assert_equal 'http://example.org/?d=&', @parser.parse('http://example.org/?d={-listjoin|,|list0}&{-join|&|foo}').value(defaults)
    
    # misc
    assert_equal 'http://example.org/foobar/baz', @parser.parse('http://example.org/{a}{b}/{a_b}').value(defaults)
    assert_equal 'http://example.org/foo/-/foo/', @parser.parse('http://example.org/{a}{-prefix|/-/|a}/').value(defaults)
  end
end
