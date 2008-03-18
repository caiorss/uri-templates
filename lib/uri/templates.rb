#--
# Copyright (C) 2007, 2008 by Stefan Saasen <s@juretta.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
require 'rubygems'
require 'treetop'
require 'cgi'

Dir[File.join(File.dirname(__FILE__), '/**/*.rb')].sort.each { |lib| require lib unless lib.eql?(__FILE__) }

module UriTemplate
  class Encoder #:nodoc:
    RESERVED = %r{:/?#\[\]@!$&'()\*\+,;=}
    
    class << self
      def unreserved(c)
        (c >= ?a and c <= ?z) or (c >= ?A and c <= ?Z) or (c >= ?0 and c <= ?9) or (c.chr !~ RESERVED)
      end
    
      def encode_unreserved(c)
        return c if unreserved(c)
        "%%%02X" % c
      end
      
      def encode(str)
        str = str.to_s
        s = ""
        str.each_byte{|b| s << encode_unreserved(b)}
        CGI.escape(s).gsub("%7E", '~').gsub("+", "%20") unless str.blank?
      end
    end
  end
  
  class URI
    # Create an instance based on tmpl
    def initialize(tmpl)
      @tmpl, @parser = tmpl, UriTemplateParser.new
      #yield self if block_given?
    end
    
    # replace template placeholder with values in vars
    def replace(vars = {})
      @parser.parse(@tmpl).value(vars)
    end
  end
end

if __FILE__ == $0
  u = UriTemplate::URI.new(DATA.read)
  puts u.replace("userID" => "stefan")
end

__END__
http://www.google.com/notebook/feeds/{userID}{-prefix|/notebooks/|notebookID}{-opt|/-/|categories}{-listjoin|/|categories}?{-join|&|updated-min,updated-max,alt,start-index,max-results,entryID,orderby}
