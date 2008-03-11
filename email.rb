module EmailAddress
  include Treetop::Runtime

  def root
    @root || :addr_spec
  end

  module AddrSpec0
    def local_part
      elements[0]
    end

    def domain
      elements[2]
    end
  end

  module AddrSpec1
    def pieces
      [ local_part.text_value, domain.text_value ]
    end
  end

  def _nt_addr_spec
    start_index = index
    if node_cache[:addr_spec].has_key?(index)
      cached = node_cache[:addr_spec][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_local_part
    s0 << r1
    if r1
      if input.index("@", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("@")
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_domain
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(AddrSpec0)
      r0.extend(AddrSpec1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:addr_spec][start_index] = r0

    return r0
  end

  def _nt_local_part
    start_index = index
    if node_cache[:local_part].has_key?(index)
      cached = node_cache[:local_part][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_dot_atom
    if r1
      r0 = r1
    else
      r2 = _nt_quoted_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:local_part][start_index] = r0

    return r0
  end

  def _nt_domain
    start_index = index
    if node_cache[:domain].has_key?(index)
      cached = node_cache[:domain][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_dot_atom
    if r1
      r0 = r1
    else
      r2 = _nt_domain_literal
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:domain][start_index] = r0

    return r0
  end

  module DomainLiteral0
    def dcontent
      elements[1]
    end
  end

  module DomainLiteral1
  end

  def _nt_domain_literal
    start_index = index
    if node_cache[:domain_literal].has_key?(index)
      cached = node_cache[:domain_literal][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r2 = _nt_CFWS
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      if input.index("[", index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("[")
        r3 = nil
      end
      s0 << r3
      if r3
        s4, i4 = [], index
        loop do
          i5, s5 = index, []
          r7 = _nt_FWS
          if r7
            r6 = r7
          else
            r6 = SyntaxNode.new(input, index...index)
          end
          s5 << r6
          if r6
            r8 = _nt_dcontent
            s5 << r8
          end
          if s5.last
            r5 = (SyntaxNode).new(input, i5...index, s5)
            r5.extend(DomainLiteral0)
          else
            self.index = i5
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = SyntaxNode.new(input, i4...index, s4)
        s0 << r4
        if r4
          r10 = _nt_FWS
          if r10
            r9 = r10
          else
            r9 = SyntaxNode.new(input, index...index)
          end
          s0 << r9
          if r9
            if input.index("]", index) == index
              r11 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("]")
              r11 = nil
            end
            s0 << r11
            if r11
              r13 = _nt_CFWS
              if r13
                r12 = r13
              else
                r12 = SyntaxNode.new(input, index...index)
              end
              s0 << r12
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(DomainLiteral1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:domain_literal][start_index] = r0

    return r0
  end

  def _nt_dcontent
    start_index = index
    if node_cache[:dcontent].has_key?(index)
      cached = node_cache[:dcontent][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_dtext
    if r1
      r0 = r1
    else
      r2 = _nt_quoted_pair
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:dcontent][start_index] = r0

    return r0
  end

  def _nt_dtext
    start_index = index
    if node_cache[:dtext].has_key?(index)
      cached = node_cache[:dtext][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_NO_WS_CTL
    if r1
      r0 = r1
    else
      if input.index(Regexp.new('[\\x21-\\x5a\\x5e-\\x7e]'), index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:dtext][start_index] = r0

    return r0
  end

  def _nt_NO_WS_CTL
    start_index = index
    if node_cache[:NO_WS_CTL].has_key?(index)
      cached = node_cache[:NO_WS_CTL][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[\\x01-\\x08\\x0b-\\x0c\\x0e-\\x1f\\x7f]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:NO_WS_CTL][start_index] = r0

    return r0
  end

  module DotAtom0
    def dot_atom_text
      elements[1]
    end

  end

  def _nt_dot_atom
    start_index = index
    if node_cache[:dot_atom].has_key?(index)
      cached = node_cache[:dot_atom][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r2 = _nt_CFWS
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      r3 = _nt_dot_atom_text
      s0 << r3
      if r3
        r5 = _nt_CFWS
        if r5
          r4 = r5
        else
          r4 = SyntaxNode.new(input, index...index)
        end
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(DotAtom0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:dot_atom][start_index] = r0

    return r0
  end

  module DotAtomText0
  end

  module DotAtomText1
  end

  def _nt_dot_atom_text
    start_index = index
    if node_cache[:dot_atom_text].has_key?(index)
      cached = node_cache[:dot_atom_text][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      r2 = _nt_atext
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      self.index = i1
      r1 = nil
    else
      r1 = SyntaxNode.new(input, i1...index, s1)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4, s4 = index, []
        if input.index(".", index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(".")
          r5 = nil
        end
        s4 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_atext
            if r7
              s6 << r7
            else
              break
            end
          end
          if s6.empty?
            self.index = i6
            r6 = nil
          else
            r6 = SyntaxNode.new(input, i6...index, s6)
          end
          s4 << r6
        end
        if s4.last
          r4 = (SyntaxNode).new(input, i4...index, s4)
          r4.extend(DotAtomText0)
        else
          self.index = i4
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(DotAtomText1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:dot_atom_text][start_index] = r0

    return r0
  end

  module FWS0
    def CRLF
      elements[1]
    end
  end

  module FWS1
  end

  def _nt_FWS
    start_index = index
    if node_cache[:FWS].has_key?(index)
      cached = node_cache[:FWS][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i2, s2 = index, []
    s3, i3 = [], index
    loop do
      r4 = _nt_WSP
      if r4
        s3 << r4
      else
        break
      end
    end
    r3 = SyntaxNode.new(input, i3...index, s3)
    s2 << r3
    if r3
      r5 = _nt_CRLF
      s2 << r5
    end
    if s2.last
      r2 = (SyntaxNode).new(input, i2...index, s2)
      r2.extend(FWS0)
    else
      self.index = i2
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      s6, i6 = [], index
      loop do
        r7 = _nt_WSP
        if r7
          s6 << r7
        else
          break
        end
      end
      if s6.empty?
        self.index = i6
        r6 = nil
      else
        r6 = SyntaxNode.new(input, i6...index, s6)
      end
      s0 << r6
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(FWS1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:FWS][start_index] = r0

    return r0
  end

  module CFWS0
    def comment
      elements[1]
    end
  end

  module CFWS1
    def comment
      elements[1]
    end
  end

  module CFWS2
  end

  def _nt_CFWS
    start_index = index
    if node_cache[:CFWS].has_key?(index)
      cached = node_cache[:CFWS][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      i2, s2 = index, []
      r4 = _nt_FWS
      if r4
        r3 = r4
      else
        r3 = SyntaxNode.new(input, index...index)
      end
      s2 << r3
      if r3
        r5 = _nt_comment
        s2 << r5
      end
      if s2.last
        r2 = (SyntaxNode).new(input, i2...index, s2)
        r2.extend(CFWS0)
      else
        self.index = i2
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    r1 = SyntaxNode.new(input, i1...index, s1)
    s0 << r1
    if r1
      i6 = index
      i7, s7 = index, []
      r9 = _nt_FWS
      if r9
        r8 = r9
      else
        r8 = SyntaxNode.new(input, index...index)
      end
      s7 << r8
      if r8
        r10 = _nt_comment
        s7 << r10
      end
      if s7.last
        r7 = (SyntaxNode).new(input, i7...index, s7)
        r7.extend(CFWS1)
      else
        self.index = i7
        r7 = nil
      end
      if r7
        r6 = r7
      else
        r11 = _nt_FWS
        if r11
          r6 = r11
        else
          self.index = i6
          r6 = nil
        end
      end
      s0 << r6
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(CFWS2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:CFWS][start_index] = r0

    return r0
  end

  def _nt_CRLF
    start_index = index
    if node_cache[:CRLF].has_key?(index)
      cached = node_cache[:CRLF][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("\r\n", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure("\r\n")
      r0 = nil
    end

    node_cache[:CRLF][start_index] = r0

    return r0
  end

  def _nt_WSP
    start_index = index
    if node_cache[:WSP].has_key?(index)
      cached = node_cache[:WSP][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[ \\t]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:WSP][start_index] = r0

    return r0
  end

  def _nt_atext
    start_index = index
    if node_cache[:atext].has_key?(index)
      cached = node_cache[:atext][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_ALPHA
    if r1
      r0 = r1
    else
      r2 = _nt_DIGIT
      if r2
        r0 = r2
      else
        if input.index(Regexp.new('[!#$\\%&\'*+\\/=?^_`{|}~-]'), index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r3 = nil
        end
        if r3
          r0 = r3
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:atext][start_index] = r0

    return r0
  end

  def _nt_ALPHA
    start_index = index
    if node_cache[:ALPHA].has_key?(index)
      cached = node_cache[:ALPHA][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[A-Za-z]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:ALPHA][start_index] = r0

    return r0
  end

  def _nt_DIGIT
    start_index = index
    if node_cache[:DIGIT].has_key?(index)
      cached = node_cache[:DIGIT][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[0-9]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:DIGIT][start_index] = r0

    return r0
  end

  def _nt_text
    start_index = index
    if node_cache[:text].has_key?(index)
      cached = node_cache[:text][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[\\x01-\\x09\\x0b-\\x0c\\x0e-\\x7f]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:text][start_index] = r0

    return r0
  end

  def _nt_specials
    start_index = index
    if node_cache[:specials].has_key?(index)
      cached = node_cache[:specials][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index(Regexp.new('[()<> \\[\\]:;@\\\\,.]'), index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r2 = _nt_DQUOTE
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:specials][start_index] = r0

    return r0
  end

  def _nt_DQUOTE
    start_index = index
    if node_cache[:DQUOTE].has_key?(index)
      cached = node_cache[:DQUOTE][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('"', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r0 = nil
    end

    node_cache[:DQUOTE][start_index] = r0

    return r0
  end

  def _nt_ccontent
    start_index = index
    if node_cache[:ccontent].has_key?(index)
      cached = node_cache[:ccontent][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_ctext
    if r1
      r0 = r1
    else
      r2 = _nt_quoted_pair
      if r2
        r0 = r2
      else
        r3 = _nt_comment
        if r3
          r0 = r3
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:ccontent][start_index] = r0

    return r0
  end

  module QuotedPair0
    def text
      elements[1]
    end
  end

  def _nt_quoted_pair
    start_index = index
    if node_cache[:quoted_pair].has_key?(index)
      cached = node_cache[:quoted_pair][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("\\", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("\\")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_text
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(QuotedPair0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:quoted_pair][start_index] = r0

    return r0
  end

  module Qtext0
    def character
      elements[1]
    end
  end

  def _nt_qtext
    start_index = index
    if node_cache[:qtext].has_key?(index)
      cached = node_cache[:qtext][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_NO_WS_CTL
    if r1
      r0 = r1
    else
      i2, s2 = index, []
      if input.index(Regexp.new('[0x21\\x23-\\x5b\\x5d-\\x7e]'), index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r3 = nil
      end
      s2 << r3
      if r3
        r4 = _nt_character
        s2 << r4
      end
      if s2.last
        r2 = (SyntaxNode).new(input, i2...index, s2)
        r2.extend(Qtext0)
      else
        self.index = i2
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:qtext][start_index] = r0

    return r0
  end

  def _nt_qcontent
    start_index = index
    if node_cache[:qcontent].has_key?(index)
      cached = node_cache[:qcontent][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_qtext
    if r1
      r0 = r1
    else
      r2 = _nt_quoted_pair
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:qcontent][start_index] = r0

    return r0
  end

  module QuotedString0
    def qcontent
      elements[1]
    end
  end

  module QuotedString1
    def DQUOTE
      elements[1]
    end

    def DQUOTE
      elements[4]
    end

  end

  def _nt_quoted_string
    start_index = index
    if node_cache[:quoted_string].has_key?(index)
      cached = node_cache[:quoted_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r2 = _nt_CFWS
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      r3 = _nt_DQUOTE
      s0 << r3
      if r3
        s4, i4 = [], index
        loop do
          i5, s5 = index, []
          r7 = _nt_FWS
          if r7
            r6 = r7
          else
            r6 = SyntaxNode.new(input, index...index)
          end
          s5 << r6
          if r6
            r8 = _nt_qcontent
            s5 << r8
          end
          if s5.last
            r5 = (SyntaxNode).new(input, i5...index, s5)
            r5.extend(QuotedString0)
          else
            self.index = i5
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = SyntaxNode.new(input, i4...index, s4)
        s0 << r4
        if r4
          r10 = _nt_FWS
          if r10
            r9 = r10
          else
            r9 = SyntaxNode.new(input, index...index)
          end
          s0 << r9
          if r9
            r11 = _nt_DQUOTE
            s0 << r11
            if r11
              r13 = _nt_CFWS
              if r13
                r12 = r13
              else
                r12 = SyntaxNode.new(input, index...index)
              end
              s0 << r12
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(QuotedString1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:quoted_string][start_index] = r0

    return r0
  end

  module Comment0
    def ccontent
      elements[1]
    end
  end

  module Comment1
  end

  def _nt_comment
    start_index = index
    if node_cache[:comment].has_key?(index)
      cached = node_cache[:comment][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("(", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("(")
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r5 = _nt_FWS
        if r5
          r4 = r5
        else
          r4 = SyntaxNode.new(input, index...index)
        end
        s3 << r4
        if r4
          r6 = _nt_ccontent
          s3 << r6
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Comment0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        r8 = _nt_FWS
        if r8
          r7 = r8
        else
          r7 = SyntaxNode.new(input, index...index)
        end
        s0 << r7
        if r7
          if input.index(")", index) == index
            r9 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(")")
            r9 = nil
          end
          s0 << r9
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Comment1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:comment][start_index] = r0

    return r0
  end

  module Ctext0
    def characters
      elements[1]
    end
  end

  def _nt_ctext
    start_index = index
    if node_cache[:ctext].has_key?(index)
      cached = node_cache[:ctext][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_NO_WS_CTL
    if r1
      r0 = r1
    else
      i2, s2 = index, []
      if input.index(Regexp.new('[\\x21-\\x27\\x2a-\\x5b\\x5d-\\x7e]'), index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r3 = nil
      end
      s2 << r3
      if r3
        r4 = _nt_characters
        s2 << r4
      end
      if s2.last
        r2 = (SyntaxNode).new(input, i2...index, s2)
        r2.extend(Ctext0)
      else
        self.index = i2
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:ctext][start_index] = r0

    return r0
  end

end

class EmailAddressParser < Treetop::Runtime::CompiledParser
  include EmailAddress
end



