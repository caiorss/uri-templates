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

Dir[File.join(File.dirname(__FILE__), 'uri_template/**/*.rb')].sort.each { |lib| require lib }

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

