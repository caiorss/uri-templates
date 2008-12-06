module UriTemplate
  include Treetop::Runtime

  def initialize
    @root = nil
  end

  def root
    @root || :uri_template
  end

  module UriTemplate0
    def uri_element
      elements[0]
    end

    def more_elements
      elements[1]
    end
  end

  module UriTemplate1
    def value(env={})
      uri_element.value(env) << more_elements.elements.map{|el| el.value(env)}.join
    end
  end

  def _nt_uri_template
    start_index = index
    if node_cache[:uri_template].has_key?(index)
      cached = node_cache[:uri_template][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_uri_element
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_uri_element
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(UriTemplate0)
      r0.extend(UriTemplate1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:uri_template][start_index] = r0

    return r0
  end

  def _nt_uri_element
    start_index = index
    if node_cache[:uri_element].has_key?(index)
      cached = node_cache[:uri_element][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_expansion
    if r1
      r0 = r1
    else
      r2 = _nt_uri_part
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:uri_element][start_index] = r0

    return r0
  end

  module Expansion0
    def c
      elements[1]
    end

  end

  module Expansion1
    def value(env = {})
      c.value(env)
    end
  end

  def _nt_expansion
    start_index = index
    if node_cache[:expansion].has_key?(index)
      cached = node_cache[:expansion][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('{', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('{')
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      r3 = _nt_var
      if r3
        r2 = r3
      else
        r4 = _nt_operator
        if r4
          r2 = r4
        else
          self.index = i2
          r2 = nil
        end
      end
      s0 << r2
      if r2
        if input.index('}', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('}')
          r5 = nil
        end
        s0 << r5
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Expansion0)
      r0.extend(Expansion1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:expansion][start_index] = r0

    return r0
  end

  module UriPart0
    def value(env = {})
      text_value
    end
  end

  def _nt_uri_part
    start_index = index
    if node_cache[:uri_part].has_key?(index)
      cached = node_cache[:uri_part][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_unreserved
    if r1
      r0 = r1
      r0.extend(UriPart0)
    else
      r2 = _nt_reserved
      if r2
        r0 = r2
        r0.extend(UriPart0)
      else
        r3 = _nt_pct_encoded
        if r3
          r0 = r3
          r0.extend(UriPart0)
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:uri_part][start_index] = r0

    return r0
  end

  def _nt_arg
    start_index = index
    if node_cache[:arg].has_key?(index)
      cached = node_cache[:arg][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_reserved
      if r2
        r1 = r2
      else
        r3 = _nt_unreserved
        if r3
          r1 = r3
        else
          r4 = _nt_pct_encoded
          if r4
            r1 = r4
          else
            self.index = i1
            r1 = nil
          end
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:arg][start_index] = r0

    return r0
  end

  module Op0
		# If each variable is undefined or an empty list then substitute the
		# empty string, otherwise substitute the value of 'arg'.
    def exec
      lambda do |env, arg, vars|
        ret = ''
        vars.split(',').each do |var| 
          if env[var] && (env[var].respond_to?(:length) ? env[var].length > 0 : true)
            ret = "#{arg}"
            break
          end
        end
        ret
      end
    end
  end

  module Op1
    # If all of the variables are un-defined or empty then substitute the
    # value of arg, otherwise substitute the empty string.
     def exec
       lambda do |env, arg, vars| 
         ret = "#{arg}"
         vars.split(',').each do |var|
           if !env[var].to_s.blank?
             ret = ""
             break
           end
         end
         ret
       end
     end
  end

  module Op2
    # The prefix operator MUST only have one variable in its expansion.  If
    # the variable is defined and non-empty then substitute the value of
    # arg followed by the value of the variable, otherwise substitute the
    # empty string.
     def exec
       lambda do |env, prefix, vars| 
         v = env[vars]
         if vars =~ /([^=]+)=([^=]+)/
           var, default = $1.dup, $2.dup
           v = env[var]
           v = default if v.to_s.blank?
         end
         !v.blank? ? "#{prefix}#{UriTemplate::Encoder.encode(v)}" : ""
       end
     end
  end

  module Op3
    # The suffix operator MUST only have one variable in its expansion.  If
    # the variable is defined and non-empty then substitute the value of
    # the variable followed by the value of arg, otherwise substitute the
    # empty string.
     def exec
       lambda do |env, append, vars|
         v = env[vars]
         if vars =~ /([^=]+)=([^=]+)/
           var, default = $1.dup, $2.dup
           v = env[var]
           v = default if v.to_s.blank?
         end  
         if v
           val = UriTemplate::Encoder.encode(v)
           !val.blank? ? "#{val}#{append}" : ""
         else
           ''
         end
       end
     end
  end

  module Op4
    # For each variable that is defined and non-empty create a keyvalue
    # string that is the concatenation of the variable name, "=", and the
    # variable value.  Concatenate more than one keyvalue string with
    # intervening values of arg to create the substitution value.
    def exec
       lambda do |env, joinop, vars| 
         vars.split(',').map do |var|
         v = env[var]
         if var =~ /([^=]+)=([^=]+)/
           var, default = $1.dup, $2.dup
           v = env[var]
           v = default if v.to_s.blank?
         end
         "#{var}=#{UriTemplate::Encoder.encode(v)}" if v
       end.compact.join(joinop)
     end
    end
  end

  module Op5
    # 	The listjoin operator MUST have only one variable in its expansion
    # and that variable must be a list.  More than one variable is an
    # error.  If the list is non-empty then substitute the concatenation of
    # all the list members with intervening values of arg.  If the list is
    # empty or the variable is undefined them substitute the empty string.
     def exec
       lambda do |env, joinop, vars|
         return "" unless env[vars].respond_to? :each
         env[vars].map do |v|
           "#{UriTemplate::Encoder.encode(v)}" if v
         end.compact.join(joinop)
       end
     end
  end

  def _nt_op
    start_index = index
    if node_cache[:op].has_key?(index)
      cached = node_cache[:op][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('opt', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 3))
      r1.extend(Op0)
      @index += 3
    else
      terminal_parse_failure('opt')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('neg', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 3))
        r2.extend(Op1)
        @index += 3
      else
        terminal_parse_failure('neg')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index('prefix', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 6))
          r3.extend(Op2)
          @index += 6
        else
          terminal_parse_failure('prefix')
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index('suffix', index) == index
            r4 = (SyntaxNode).new(input, index...(index + 6))
            r4.extend(Op3)
            @index += 6
          else
            terminal_parse_failure('suffix')
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if input.index('join', index) == index
              r5 = (SyntaxNode).new(input, index...(index + 4))
              r5.extend(Op4)
              @index += 4
            else
              terminal_parse_failure('join')
              r5 = nil
            end
            if r5
              r0 = r5
            else
              if input.index('list', index) == index
                r6 = (SyntaxNode).new(input, index...(index + 4))
                r6.extend(Op5)
                @index += 4
              else
                terminal_parse_failure('list')
                r6 = nil
              end
              if r6
                r0 = r6
              else
                self.index = i0
                r0 = nil
              end
            end
          end
        end
      end
    end

    node_cache[:op][start_index] = r0

    return r0
  end

  module Vars0
    def var
      elements[1]
    end
  end

  module Vars1
    def var
      elements[0]
    end

  end

  def _nt_vars
    start_index = index
    if node_cache[:vars].has_key?(index)
      cached = node_cache[:vars][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_var
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        if input.index(",", index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(",")
          r4 = nil
        end
        s3 << r4
        if r4
          r5 = _nt_var
          s3 << r5
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Vars0)
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
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Vars1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:vars][start_index] = r0

    return r0
  end

  def _nt_vardefault
    start_index = index
    if node_cache[:vardefault].has_key?(index)
      cached = node_cache[:vardefault][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_unreserved
      if r2
        r1 = r2
      else
        r3 = _nt_pct_encoded
        if r3
          r1 = r3
        else
          self.index = i1
          r1 = nil
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:vardefault][start_index] = r0

    return r0
  end

  module Var0
    def vardefault
      elements[1]
    end
  end

  module Var1
    def varname
      elements[0]
    end

    def defaults
      elements[1]
    end
  end

  module Var2
    def value(env={} )
      return UriTemplate::Encoder.encode(env[name]) unless env[name].nil?
      defaults.text_value.gsub(/=/, '')
    end
      
    def name
      varname.text_value
    end
  end

  def _nt_var
    start_index = index
    if node_cache[:var].has_key?(index)
      cached = node_cache[:var][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_varname
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        if input.index('=', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('=')
          r4 = nil
        end
        s3 << r4
        if r4
          r5 = _nt_vardefault
          s3 << r5
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Var0)
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
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Var1)
      r0.extend(Var2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:var][start_index] = r0

    return r0
  end

  module Operator0
    def op
      elements[1]
    end

    def arg
      elements[3]
    end

    def vars
      elements[5]
    end
  end

  module Operator1

    def value(env={})
      op.exec.call(env, arg.text_value, vars.text_value) # if op.respond_to?(:exec)
    end
  end

  def _nt_operator
    start_index = index
    if node_cache[:operator].has_key?(index)
      cached = node_cache[:operator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("-", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("-")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_op
      s0 << r2
      if r2
        if input.index("|", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("|")
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_arg
          s0 << r4
          if r4
            if input.index("|", index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("|")
              r5 = nil
            end
            s0 << r5
            if r5
              r6 = _nt_vars
              s0 << r6
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Operator0)
      r0.extend(Operator1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:operator][start_index] = r0

    return r0
  end

  module Varname0
  end

  def _nt_varname
    start_index = index
    if node_cache[:varname].has_key?(index)
      cached = node_cache[:varname][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index(Regexp.new('[a-zA-Z0-9]'), index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if input.index(Regexp.new('[a-zA-Z0-9_.-]'), index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
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
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Varname0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:varname][start_index] = r0

    return r0
  end

  def _nt_alpha
    start_index = index
    if node_cache[:alpha].has_key?(index)
      cached = node_cache[:alpha][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[A-Za-z_]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:alpha][start_index] = r0

    return r0
  end

  def _nt_alphanumeric
    start_index = index
    if node_cache[:alphanumeric].has_key?(index)
      cached = node_cache[:alphanumeric][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_alpha
    if r1
      r0 = r1
    else
      if input.index(Regexp.new('[0-9]'), index) == index
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

    node_cache[:alphanumeric][start_index] = r0

    return r0
  end

  def _nt_unreserved
    start_index = index
    if node_cache[:unreserved].has_key?(index)
      cached = node_cache[:unreserved][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_alphanumeric
    if r1
      r0 = r1
    else
      if input.index("-", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("-")
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index(".", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(".")
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index("_", index) == index
            r4 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("_")
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if input.index("~", index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("~")
              r5 = nil
            end
            if r5
              r0 = r5
            else
              self.index = i0
              r0 = nil
            end
          end
        end
      end
    end

    node_cache[:unreserved][start_index] = r0

    return r0
  end

  module PctEncoded0
    def hexdig
      elements[1]
    end

    def hexdig
      elements[2]
    end
  end

  def _nt_pct_encoded
    start_index = index
    if node_cache[:pct_encoded].has_key?(index)
      cached = node_cache[:pct_encoded][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('%', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('%')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_hexdig
      s0 << r2
      if r2
        r3 = _nt_hexdig
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(PctEncoded0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:pct_encoded][start_index] = r0

    return r0
  end

  def _nt_hexdig
    start_index = index
    if node_cache[:hexdig].has_key?(index)
      cached = node_cache[:hexdig][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[a-fA-F0-9]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:hexdig][start_index] = r0

    return r0
  end

  def _nt_reserved
    start_index = index
    if node_cache[:reserved].has_key?(index)
      cached = node_cache[:reserved][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_gen_delims
    if r1
      r0 = r1
    else
      r2 = _nt_sub_delims
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:reserved][start_index] = r0

    return r0
  end

  def _nt_gen_delims
    start_index = index
    if node_cache[:gen_delims].has_key?(index)
      cached = node_cache[:gen_delims][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index(":", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(":")
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index("/", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("/")
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index("?", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("?")
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index("#", index) == index
            r4 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("#")
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if input.index("[", index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("[")
              r5 = nil
            end
            if r5
              r0 = r5
            else
              if input.index("]", index) == index
                r6 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("]")
                r6 = nil
              end
              if r6
                r0 = r6
              else
                if input.index("@", index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("@")
                  r7 = nil
                end
                if r7
                  r0 = r7
                else
                  self.index = i0
                  r0 = nil
                end
              end
            end
          end
        end
      end
    end

    node_cache[:gen_delims][start_index] = r0

    return r0
  end

  def _nt_sub_delims
    start_index = index
    if node_cache[:sub_delims].has_key?(index)
      cached = node_cache[:sub_delims][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index("!", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("!")
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index("$", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("$")
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index("&", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("&")
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index("'", index) == index
            r4 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("'")
            r4 = nil
          end
          if r4
            r0 = r4
          else
            if input.index("(", index) == index
              r5 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("(")
              r5 = nil
            end
            if r5
              r0 = r5
            else
              if input.index(")", index) == index
                r6 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure(")")
                r6 = nil
              end
              if r6
                r0 = r6
              else
                if input.index("*", index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("*")
                  r7 = nil
                end
                if r7
                  r0 = r7
                else
                  if input.index("+", index) == index
                    r8 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("+")
                    r8 = nil
                  end
                  if r8
                    r0 = r8
                  else
                    if input.index(",", index) == index
                      r9 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure(",")
                      r9 = nil
                    end
                    if r9
                      r0 = r9
                    else
                      if input.index(";", index) == index
                        r10 = (SyntaxNode).new(input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(";")
                        r10 = nil
                      end
                      if r10
                        r0 = r10
                      else
                        if input.index("=", index) == index
                          r11 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure("=")
                          r11 = nil
                        end
                        if r11
                          r0 = r11
                        else
                          self.index = i0
                          r0 = nil
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:sub_delims][start_index] = r0

    return r0
  end

end

class UriTemplateParser < Treetop::Runtime::CompiledParser
  include UriTemplate
end

