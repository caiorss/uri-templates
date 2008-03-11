# use_grammar.rb
require 'rubygems'
require 'treetop'

Treetop.load 'grammar/ut'
    
parser = AviarcParser.new
v = parser.parse('http{foo}')         
p v
#p v.input
#p v.elements

