module Aviarc
  include Treetop::Runtime

  def root
    @root || :variable
  end

  module Variable0
    def replace!
      "replace #{self}"
    end
  end

  def _nt_variable
    start_index = index
    if node_cache[:variable].has_key?(index)
      cached = node_cache[:variable][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('{foo}', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 5))
      r0.extend(Variable0)
      @index += 5
    else
      terminal_parse_failure('{foo}')
      r0 = nil
    end

    node_cache[:variable][start_index] = r0

    return r0
  end

  def _nt_ignore
    start_index = index
    if node_cache[:ignore].has_key?(index)
      cached = node_cache[:ignore][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[a-z]'), index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:ignore][start_index] = r0

    return r0
  end

end

class AviarcParser < Treetop::Runtime::CompiledParser
  include Aviarc
end

