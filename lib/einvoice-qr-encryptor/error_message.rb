module EInvoiceQREncryptor
  class ErrorMessage # :nodoc:
    def self.generate(params)
      case params[:msg]
      when :field_should_be
        "The #{params[:field]} should be #{params[:data]}"
      when :fixed_length
        "The length for #{params[:field]} should be #{params[:length]}"
      when :cannot_be_empty
        "The #{params[:field]} cannot be empty"
      end
    end
  end
end
