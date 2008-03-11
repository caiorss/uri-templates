# use_grammar.rb
require 'rubygems'
require 'treetop'

Treetop.load 'grammar/uri_template'
    
parser = UriTemplateParser.new
#v = parser.parse('http{foo}')         
#p v
#p v.input
#p v.elements

parser = UriTemplateParser.new
v = parser.parse('http://{foo}')
#p v.name if v.respond_to? :name
print "value: "
p v.value if v.respond_to? :value
#p v

#parser = UriTemplateParser.new
#v = parser.parse('{foo}{bar}')
#p v

