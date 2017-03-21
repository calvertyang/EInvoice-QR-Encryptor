[![Gem Version](https://badge.fury.io/rb/einvoice-qr-encryptor.svg)](http://badge.fury.io/rb/einvoice-qr-encryptor)
[![Build Status](https://travis-ci.org/CalvertYang/EInvoice-QR-Encryptor.svg?branch=master)](https://travis-ci.org/CalvertYang/EInvoice-QR-Encryptor)
![Analytics](https://ga-beacon.appspot.com/UA-44933497-3/CalvertYang/EInvoice-QR-Encryptor?pixel)
# EInvoice-QR-Encryptor

Encrypt, decrypt and generate QR code information for EInvoice(Taiwan)

_Compatible with 1D and 2D barcode specification version 1.6(20161115)_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'einvoice-qr-encryptor'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install einvoice-qr-encryptor
```

## Usage

```ruby
cipher = EInvoiceQREncryptor::Cipher.new('FE0F50D87215F625D1248F5FDAEBA37F')
```

#### Encrypt plain text

```ruby
cipher.encrypt('AA123456781234')
#=> '73UqXrAk5DsVNv2VEvIFkQ=='
```

#### Decrypt cipher text

```ruby
cipher.decrypt('73UqXrAk5DsVNv2VEvIFkQ==')
#=> 'AA123456781234'
```

#### Generate QR Code information for EInvoice

```ruby
cipher.gen_qrcode_information(
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
#=> 'AA12345678104051112340000006400000064000000000000000073UqXrAk5DsVNv2VEvIFkQ=='
```

#### Generate Barcode and QR Code information for EInvoice

```ruby
cipher.gen_barcode_qrcode_information(
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
#=> {
#     :barcode=>"10405AA123456781234",
#     :qrcode_left=>"AA12345678104051112340000006400000064000000000000000073UqXrAk5DsVNv2VEvIFkQ==:**********:0:2:1",
#     :qrcode_right=>"**"
#   }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CalvertYang/EInvoice-QR-Encryptor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
