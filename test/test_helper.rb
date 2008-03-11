# $Id: test_helper.rb 94 2006-12-24 13:05:36Z stefan $
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/uri_templates'
FIXTURES = File.dirname(__FILE__) + "/fixtures"
 
def read_fixture(f)
  File.read(File.join(FIXTURES, f))
end
