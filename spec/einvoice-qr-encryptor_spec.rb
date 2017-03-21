require 'spec_helper'

RSpec.describe EInvoiceQREncryptor do
  before :all do
    @cipher = EInvoiceQREncryptor::Cipher.new('FE0F50D87215F625D1248F5FDAEBA37F')
  end

  it 'has a version number' do
    expect(EInvoiceQREncryptor::VERSION).not_to be nil
  end

  context '#encrypt' do
    it 'is invalid with wrong number of arguments' do
      expect do
        @cipher.encrypt
      end.to raise_error ArgumentError
    end

    it 'is invalid without aes_key' do
      expect do
        EInvoiceQREncryptor::Cipher.new.encrypt('AA123456781234')
      end.to raise_error RuntimeError, 'The aes_key cannot be empty'
    end

    it 'can encrypt plain text' do
      expect(@cipher.encrypt('AA123456781234')).to eq '73UqXrAk5DsVNv2VEvIFkQ=='
    end
  end

  context '#decrypt' do
    it 'is invalid with wrong number of arguments' do
      expect do
        @cipher.decrypt
      end.to raise_error ArgumentError
    end

    it 'is invalid without aes_key' do
      expect do
        EInvoiceQREncryptor::Cipher.new.decrypt('73UqXrAk5DsVNv2VEvIFkQ==')
      end.to raise_error RuntimeError, 'The aes_key cannot be empty'
    end

    it 'can decrypt cipher text' do
      expect(@cipher.decrypt('73UqXrAk5DsVNv2VEvIFkQ==')).to eq 'AA123456781234'
    end
  end

  context '#gen_qrcode_information' do
    it 'is invalid with wrong number of arguments' do
      expect do
        @cipher.gen_qrcode_information
      end.to raise_error ArgumentError
    end

    it 'is invalid without aes_key' do
      expect do
        EInvoiceQREncryptor::Cipher.new.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The aes_key cannot be empty'
    end

    it 'can validate type of invoice_number' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 12_345_678,
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The invoice_number should be String'
    end

    it 'can validate length of invoice_number' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'A12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The length for invoice_number should be 10'
    end

    it 'can validate type of invoice_date' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: 1_040_511,
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The invoice_date should be String'
    end

    it 'can validate length of invoice_date' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '104051',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The length for invoice_date should be 7'
    end

    it 'can validate month range of invoice_date' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1041311',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The month of invoice_date should be between 01 ~ 12'
    end

    it 'can validate month range of invoice_date' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040532',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The day of invoice_date should be between 01 ~ 31'
    end

    it 'can validate type of random_number' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: 1234,
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The random_number should be String'
    end

    it 'can validate length of random_number' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '123',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The length for random_number should be 4'
    end

    it 'can validate type of sales_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: '100',
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The sales_amount should be Integer'
    end

    it 'can validate sales_amount cannot be negative' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: -100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The sales_amount should be greater than or equal to 0'
    end

    it 'can validate type of tax_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: '0',
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The tax_amount should be Integer'
    end

    it 'can validate tax_amount cannot be negative' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: -5,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The tax_amount should be greater than or equal to 0'
    end

    it 'can validate type of total_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: '100',
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The total_amount should be Integer'
    end

    it 'can validate total_amount cannot be negative' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: -100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The total_amount should be greater than or equal to 0'
    end

    it 'can validate type of buyer_identifier' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: 0,
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The buyer_identifier should be String'
    end

    it 'can validate buyer_identifier cannot be negative' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '0000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The length for buyer_identifier should be 8'
    end

    it 'can validate type of seller_identifier' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: 0,
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The seller_identifier should be String'
    end

    it 'can validate seller_identifier cannot be negative' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '0000000',
          business_identifier: '00000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The length for seller_identifier should be 8'
    end

    it 'can validate type of business_identifier' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: 0,
          product_array: []
        )
      end.to raise_error RuntimeError, 'The business_identifier should be String'
    end

    it 'can validate business_identifier cannot be negative' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '0000000',
          product_array: []
        )
      end.to raise_error RuntimeError, 'The length for business_identifier should be 8'
    end

    it 'can validate type of product_array' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: ''
        )
      end.to raise_error RuntimeError, 'The product_array should be Array'
    end

    it 'can validate type of product_array.product_code' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: 0,
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_code should be String'
    end

    it 'can validate length of product_array.product_code' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_code cannot be empty'
    end

    it 'can validate type of product_array.product_name' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: 0,
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_name should be String'
    end

    it 'can validate length of product_array.product_name' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_name cannot be empty'
    end

    it 'can validate type of product_array.product_qty' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: 1,
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_qty should be String'
    end

    it 'can validate length of product_array.product_qty' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_qty cannot be empty'
    end

    it 'can validate format of product_array.product_qty' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: 'abc',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_qty should be number string'
    end

    it 'can validate type of product_array.product_sale_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: 100,
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_sale_amount should be String'
    end

    it 'can validate length of product_array.product_sale_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_sale_amount cannot be empty'
    end

    it 'can validate format of product_array.product_sale_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: 'abc',
            product_tax_amount: '0',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_sale_amount should be number string'
    end

    it 'can validate type of product_array.product_tax_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: 0,
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_tax_amount should be String'
    end

    it 'can validate length of product_array.product_tax_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_tax_amount cannot be empty'
    end

    it 'can validate format of product_array.product_tax_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: 'abc',
            product_amount: '100'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_tax_amount should be number string'
    end

    it 'can validate type of product_array.product_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: 100
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_amount should be String'
    end

    it 'can validate length of product_array.product_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: ''
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_amount cannot be empty'
    end

    it 'can validate format of product_array.product_amount' do
      expect do
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575609',
            product_name: '商品名稱',
            product_qty: '1',
            product_sale_amount: '100',
            product_tax_amount: '0',
            product_amount: 'abc'
          }]
        )
      end.to raise_error RuntimeError, 'The product_array.product_amount should be number string'
    end

    it 'can generate QR code information for EInvoice' do
      expect(
        @cipher.gen_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: []
        )
      ).to eq 'AA12345678104051112340000006400000064000000000000000073UqXrAk5DsVNv2VEvIFkQ=='
    end

    it 'can generate Barcode and QR code information for EInvoice' do
      expect(
        @cipher.gen_barcode_qrcode_information(
          invoice_number: 'AA12345678',
          invoice_date: '1040511',
          invoice_time: '090000',
          random_number: '1234',
          sales_amount: 100,
          tax_amount: 0,
          total_amount: 100,
          buyer_identifier: '00000000',
          represent_identifier: '00000000',
          seller_identifier: '00000000',
          business_identifier: '00000000',
          product_array: [{
            product_code: '4713546575601',
            product_name: 'Product 1',
            product_qty: '1',
            product_sale_amount: '60',
            product_tax_amount: '0',
            product_amount: '60'
          }, {
            product_code: '4713546575602',
            product_name: 'Product 2',
            product_qty: '2',
            product_sale_amount: '20',
            product_tax_amount: '0',
            product_amount: '20'
          }]
        )
      ).to eq(
        barcode: '10405AA123456781234',
        qrcode_left: 'AA12345678104051112340000006400000064000000000000000073UqXrAk5DsVNv2VEvIFkQ==:**********:0:2:1',
        qrcode_right: '**'
      )
    end
  end
end
