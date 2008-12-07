#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/uri/templates'
FIXTURES = (File.dirname(__FILE__) + "/fixtures").freeze
#Treetop.load File.dirname(__FILE__) + '/../grammar/uri_template'
#def read_fixture(f)
#  File.read(File.join(FIXTURES, f))
#end

module Unicode
  def self.const_missing(name)  
    # Check that the constant name is of the right form: U0000 to U10FFFF
    if name.to_s =~ /^U([0-9a-fA-F]{4,5}|10[0-9a-fA-F]{4})$/
      # Convert the codepoint to an immutable UTF-8 string,
      # define a real constant for that value and return the value
      #p name, name.class
      const_set(name, [$1.dup.to_i(16)].pack("U").freeze)
    else  # Raise an error for constants that are not Unicode.
      raise NameError, "Uninitialized constant: Unicode::#{name}"
    end
  end
end