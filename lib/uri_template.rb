require 'rubygems'
require 'treetop'

require 'uri'
require 'cgi'
require File.dirname(__FILE__) + '/grammar'


class UriPart < Treetop::Runtime::SyntaxNode
  def value
    text_value
  end
end
