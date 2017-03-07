require 'openssl'
require 'base64'
require 'einvoice-qr-encryptor/error_message'
require 'einvoice-qr-encryptor/core_ext/integer'

module EInvoiceQREncryptor
  class Cipher # :nodoc:
    attr_reader :aes_key

    def initialize(aes_key = nil)
      @aes_key = aes_key
      @aes_iv = '0EDF25C93A28D7B5FF5E45DA42F8A1B8'
      @cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    end

    # Encrypt plain text
    #
    # @param plain_text [String] Plain text to encrypt
    # @return [String] Cipher text
    # @example
    #   encrypt('AA123456781234') #=> '73UqXrAk5DsVNv2VEvIFkQ=='
    def encrypt(plain_text)
      init_cipher(:encrypt)
      Base64.encode64(@cipher.update(plain_text) + @cipher.final).strip
    end

    # Decrypt cipher text
    #
    # @param cipher_text [String] Cipher text to decrypt
    # @return [String] Plain text
    # @example
    #   decrypt('73UqXrAk5DsVNv2VEvIFkQ==') #=> 'AA123456781234'
    def decrypt(cipher_text)
      init_cipher(:decrypt)
      @cipher.update(Base64.decode64(cipher_text)) + @cipher.final
    end

    # Generate QR code information for invoice
    #
    # @param invoice_number [String]
    # @param invoice_date [String]
    # @param invoice_time [String]
    # @param random_number [String]
    # @param sales_amount [Integer]
    # @param tax_amount [Integer]
    # @param total_amount [Integer]
    # @param buyer_identifier [String]
    # @param represent_identifier [String]
    # @param seller_identifier [String]
    # @param business_identifier [String]
    # @param product_arrays [Array]
    # @return [String] QR code information for invoice
    # @example
    #   gen_qrcode_information(
    #     invoice_number: 'AA12345678',
    #     invoice_date: '1040511',
    #     invoice_time: '090000',
    #     random_number: '1234',
    #     sales_amount: 100,
    #     tax_amount: 0,
    #     total_amount: 100,
    #     buyer_identifier: '00000000',
    #     represent_identifier: '00000000',
    #     seller_identifier: '00000000',
    #     business_identifier: '00000000',
    #     product_array: []
    #   ) #=> 'AA12345678104051112340000006400000064000000000000000073UqXrAk5DsVNv2VEvIFkQ=='
    def gen_qrcode_information(invoice_number:, invoice_date:, invoice_time:, random_number:, sales_amount:, tax_amount:, total_amount:, buyer_identifier:, represent_identifier:, seller_identifier:, business_identifier:, product_array:)
      # check all arguments are valid
      # 發票字軌號碼共 10 碼
      raise ErrorMessage.generate(msg: :field_should_be, field: :invoice_number, data: String) unless invoice_number.is_a? String
      raise ErrorMessage.generate(msg: :fixed_length, field: :invoice_number, length: 10) if invoice_number.length != 10

      # 發票開立年月日(中華民國年份月份日期)共 7 碼
      raise ErrorMessage.generate(msg: :field_should_be, field: :invoice_date, data: String) unless invoice_date.is_a? String
      raise ErrorMessage.generate(msg: :fixed_length, field: :invoice_date, length: 7) if invoice_date.length != 7

      /\d{3}(?<month>\d{2})(?<day>\d{2})/ =~ invoice_date
      raise ErrorMessage.generate(msg: :field_should_be, field: 'month of invoice_date', data: 'between 01 ~ 12') unless ('01'..'12').cover? month
      raise ErrorMessage.generate(msg: :field_should_be, field: 'day of invoice_date', data: 'between 01 ~ 31') unless ('01'..'31').cover? day

      # 發票開立時間 (24 小時制) 共 6 碼，以時時分分秒秒方式之字串表示
      # raise ErrorMessage.generate(msg: :field_should_be, field: :invoice_time, data: String) unless invoice_time.is_a? String
      # raise ErrorMessage.generate(msg: :fixed_length, field: :invoice_time, length: 6) if invoice_time.length != 6

      # 4 位隨機碼
      raise ErrorMessage.generate(msg: :field_should_be, field: :random_number, data: String) unless random_number.is_a? String
      raise ErrorMessage.generate(msg: :fixed_length, field: :random_number, length: 4) if random_number.length != 4

      # 銷售額(未稅)
      raise ErrorMessage.generate(msg: :field_should_be, field: :sales_amount, data: Integer) unless sales_amount.is_a? Integer
      raise ErrorMessage.generate(msg: :field_should_be, field: :sales_amount, data: 'greater than or equal to 0') if sales_amount < 0

      # 稅額
      raise ErrorMessage.generate(msg: :field_should_be, field: :tax_amount, data: Integer) unless tax_amount.is_a? Integer
      raise ErrorMessage.generate(msg: :field_should_be, field: :tax_amount, data: 'greater than or equal to 0') if tax_amount. < 0

      # 總計金額(含稅)
      raise ErrorMessage.generate(msg: :field_should_be, field: :total_amount, data: Integer) unless total_amount.is_a? Integer
      raise ErrorMessage.generate(msg: :field_should_be, field: :total_amount, data: 'greater than or equal to 0') if total_amount. < 0

      # 買受人統一編號
      raise ErrorMessage.generate(msg: :field_should_be, field: :buyer_identifier, data: String) unless buyer_identifier.is_a? String
      raise ErrorMessage.generate(msg: :fixed_length, field: :buyer_identifier, length: 8) if buyer_identifier.length != 8

      # 代表店統一編號，目前電子發票證明聯二維條碼規格已不使用代表店
      # raise ErrorMessage.generate(msg: :field_should_be, field: :represent_identifier, data: String) unless represent_identifier.is_a? String
      # raise ErrorMessage.generate(msg: :fixed_length, field: :represent_identifier, length: 8) if represent_identifier.length != 8

      # 銷售店統一編號
      raise ErrorMessage.generate(msg: :field_should_be, field: :seller_identifier, data: String) unless seller_identifier.is_a? String
      raise ErrorMessage.generate(msg: :fixed_length, field: :seller_identifier, length: 8) if seller_identifier.length != 8

      # 總公司統一編號，如無總公司請填入銷售店統一編號
      raise ErrorMessage.generate(msg: :field_should_be, field: :business_identifier, data: String) unless business_identifier.is_a? String
      raise ErrorMessage.generate(msg: :fixed_length, field: :business_identifier, length: 8) if business_identifier.length != 8

      # 商品資訊
      raise ErrorMessage.generate(msg: :field_should_be, field: :product_array, data: Array) unless product_array.is_a? Array

      product_array.each do |product|
        # 透過條碼槍所掃出之條碼資訊
        raise ErrorMessage.generate(msg: :field_should_be, field: 'product_array.product_code', data: String) unless product[:product_code].is_a? String
        raise ErrorMessage.generate(msg: :cannot_be_empty, field: 'product_array.product_code') if product[:product_code].empty?

        # 商品名稱
        raise ErrorMessage.generate(msg: :field_should_be, field: 'product_array.product_name', data: String) unless product[:product_name].is_a? String
        raise ErrorMessage.generate(msg: :cannot_be_empty, field: 'product_array.product_name') if product[:product_name].empty?

        # 商品數量
        raise ErrorMessage.generate(msg: :field_should_be, field: 'product_array.product_qty', data: String) unless product[:product_qty].is_a? String
        raise ErrorMessage.generate(msg: :cannot_be_empty, field: 'product_array.product_qty') if product[:product_qty].empty?

        # 商品銷售額(整數未稅)，若無法分離稅項則記載為字串 0
        raise ErrorMessage.generate(msg: :field_should_be, field: 'product_array.product_sale_amount', data: String) unless product[:product_sale_amount].is_a? String
        raise ErrorMessage.generate(msg: :cannot_be_empty, field: 'product_array.product_sale_amount') if product[:product_sale_amount].empty?

        # 商品稅額(整數)，若無法分離稅項則記載為字串 0
        raise ErrorMessage.generate(msg: :field_should_be, field: 'product_array.product_tax_amount', data: String) unless product[:product_tax_amount].is_a? String
        raise ErrorMessage.generate(msg: :cannot_be_empty, field: 'product_array.product_tax_amount') if product[:product_tax_amount].empty?

        # 商品金額(整數含稅)
        raise ErrorMessage.generate(msg: :field_should_be, field: 'product_array.product_amount', data: String) unless product[:product_amount].is_a? String
        raise ErrorMessage.generate(msg: :cannot_be_empty, field: 'product_array.product_amount') if product[:product_amount].empty?
      end

      # generate cipher text
      cipher_text = encrypt("#{invoice_number}#{random_number}")

      # return QR Code invoice information
      "#{invoice_number}#{invoice_date}#{random_number}" \
      "#{sales_amount.to_8bit_hex_string}#{total_amount.to_8bit_hex_string}" \
      "#{buyer_identifier}#{seller_identifier}#{cipher_text}"
    end

    private

    def init_cipher(type)
      raise ErrorMessage.generate(msg: :cannot_be_empty, field: :aes_key) if @aes_key.nil? || @aes_key.empty?

      @cipher.send(type)
      @cipher.key = [@aes_key].pack('H*')
      @cipher.iv = [@aes_iv].pack('H*')
    end
  end
end
