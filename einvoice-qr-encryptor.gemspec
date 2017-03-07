# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'einvoice-qr-encryptor/version'

Gem::Specification.new do |spec|
  spec.name          = 'einvoice-qr-encryptor'
  spec.version       = EInvoiceQREncryptor::VERSION
  spec.authors       = ['Calvert']
  spec.email         = ['']

  spec.summary       = 'E-Invoice QR code information encryptor'
  spec.description   = 'Encrypt, decrypt and generate QR code information for einvoice(Taiwan)'
  spec.homepage      = 'https://github.com/calvertyang/EInvoice-QR-Encryptor'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.5'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'
  spec.add_development_dependency 'simplecov', '~> 0.13.0'
end
