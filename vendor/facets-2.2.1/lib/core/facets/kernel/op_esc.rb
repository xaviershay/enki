module Kernel

  # TODO: Is there any good way to avoid 'unless const_defined?'.

  unless const_defined?("OPERATORS")
    OPERATORS = %w{ +@ -@ + - ** * / % ~ <=> << >> < > === == =~ <= >= | & ^ []= [] }
    OPERATORS_REGEXP = Regexp.new( '(' << OPERATORS.collect{ |k| Regexp.escape(k) }.join('|') << ')' )
    OPERATORS_ESC_TABLE = {
        "+@"   => "op_plus_self",
        "-@"   => "op_minus_self",
        "+"    => "op_plus",
        "-"    => "op_minus",
        "**"   => "op_pow",
        "*"    => "op_mul",
        "/"    => "op_div",
        "%"    => "op_mod",
        "~"    => "op_tilde",
        "<=>"  => "op_cmp",
        "<<"   => "op_lshift",
        ">>"   => "op_rshift",
        "<"    => "op_lt",
        ">"    => "op_gt",
        "==="  => "op_case_eq",
        "=="   => "op_equal",
        "=~"   => "op_apply",
        "<="   => "op_lt_eq",
        ">="   => "op_gt_eq",
        "|"    => "op_or",
        "&"    => "op_and",
        "^"    => "op_xor",
        "[]="  => "op_store",
        "[]"   => "op_fetch"
    }
  end

  # Applies operator escape's according to OPERATORS_ESCAPE_TABLE.
  #
  #   op_esc('-') #=> "op_minus"
  #
  #   CREDIT: Trans

  def op_esc( str )
    str.gsub(OPERATORS_REGEXP){ OPERATORS_ESC_TABLE[$1] }
  end

  # NOTE: op_esc used to support the method require_esc.
  #
  #   # Require a file with puncuation marks escaped.
  #   #
  #   #   require_esc '[].rb'
  #   #
  #   # in actuality requires the file 'op_fetch.rb'.
  #
  #   def require_esc( fpath )
  #     fdir, fname = File.split(fpath)
  #     ename = op_esc( fname )
  #     case ename[-1,1] ; when '!','=','?' then ename = ename[0...-1] ; end
  #     epath = File.join( fdir, ename )
  #     require( epath )
  #   end

end
