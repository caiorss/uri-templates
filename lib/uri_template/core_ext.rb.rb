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