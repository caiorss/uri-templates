#  Created by Stefan Saasen.
#  Copyright (c) 2008. All rights reserved.

class NilClass #:nodoc:
  def blank?
    true
  end
end

class String #:nodoc:
  def ord
    self[0]
  end
  
  def blank?
    nil? || size < 1
  end
end