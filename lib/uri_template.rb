require 'rubygems'
require 'treetop'
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), './')))
$:.uniq!
require 'uri_template/version'
require 'uri_template/grammar'

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

