# use_grammar.rb
require 'rubygems'
require 'treetop'
require 'cgi'
require 'pp'

Treetop.load 'grammar/uri_template'


parser = UriTemplateParser.new
#v = parser.parse('http://{foo}/{bar}')


#puts v.value("foo" => "stefan", 'bar' => 'sarah')

v = parser.parse('http://example.org/{foo=fred}')
pp v
pp v.value("foo3" => "stefan", 'bar' => 'sarah')