class Integer # :nodoc:
  # Convert integer to 8-bit hexadecimal
  #
  # @example
  #   100.to_8bit_hex_string #=> "00000064"
  def to_8bit_hex_string
    to_s(16).rjust(8, '0')
  end
end
