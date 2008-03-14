require 'rubygems'
require 'treetop'

require 'cgi'

#$KCODE='u'

class NilClass
  def blank?
    true
  end
end

class String
  def ord
    self[0]
  end
  
  def blank?
    nil? || size < 1
  end
end

module UriTemplate
  class Encoder
    RESERVED = %r{:/?#\[\]@!$&'()\*\+,;=}
    class << self
    
      def unreserved(c)
        (c >= ?a and c <= ?z) or (c >= ?A and c <= ?Z) or (c >= ?0 and c <= ?9) or (c.chr !~ RESERVED)
      end
    
      def encode_unreserved(c)
        return c if unreserved(c)
        sprintf("%%%02X", c)   
      end
      
      def encode(str)
        s = ""
        str.each_byte{|b| s << encode_unreserved(b)}
	CGI.escape(s).gsub("%7E", '~').gsub("+", "%20") unless str.blank?
      end
    end
  end
end



require File.dirname(__FILE__) + '/grammar'


class UriPart < Treetop::Runtime::SyntaxNode
  def value
    text_value
  end
end
