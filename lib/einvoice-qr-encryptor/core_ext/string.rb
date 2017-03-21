class String # :nodoc:
  # Check string is numeric or not
  #
  # @example
  #   'abc'.numeric? #=> false
  #   '123'.numeric? #=> true
  def numeric?
    true if Float(self)
  rescue
    false
  end
end
