class NilClass

  # Nil#status makes it possible to pass messages
  # through a "failure" chain.
  #
  #   def foo
  #     return nil.status("failed foo!")
  #   end
  #
  #   result = foo
  #   if result.nil?
  #     result.status?  #=> true
  #     result.status   #=> "failed foo!"
  #   end
  #
  #   CREDIT: Trans

  def status(status=nil)
    if status
      @status = status
      self
    else
      @status
    end
  end

  # Check status.
  #
  #   def foo
  #     return nil.status("failed foo!")
  #   end
  #
  #   result = foo
  #   if result.nil?
  #     result.status?  #=> true
  #     result.status   #=> "failed foo!"
  #   end
  #
  #   CREDIT: Trans

  def status?
    return unless @status
    return false if @status.empty?
    return true
  end

end
