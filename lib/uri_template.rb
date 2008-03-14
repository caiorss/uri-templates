require 'rubygems'
require 'treetop'

require 'uri'
require 'cgi'

class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    nil? || size < 1
  end
end

require File.dirname(__FILE__) + '/grammar'


class UriPart < Treetop::Runtime::SyntaxNode
  def value
    text_value
  end
end
