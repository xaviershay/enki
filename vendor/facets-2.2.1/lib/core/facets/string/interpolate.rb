class String

  class << self

    # Interpolate. Provides a means of extenally using
    # Ruby string interpolation mechinism.
    #
    #   try = "hello"
    #   str = "\#{try}!!!"
    #   String.interpolate{ str }    #=> "hello!!!"
    #
    #   NOTE: The block neccessary in order to get
    #         then binding of the caller.
    #
    #   CREDIT: Trans

    def interpolate(&str)
      eval "%{#{str.call}}", str.binding
    end

    # Module method tied to Kernel#format.
    public :format

    # Module method tied to Kernel#sprintf.
    public :sprintf

  end

  # Alias for % as format.
  alias_method :format, :%

  # Alias for % as sprintf.
  alias_method :sprintf, :%

end
