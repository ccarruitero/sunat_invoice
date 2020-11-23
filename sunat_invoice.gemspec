# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'sunat_invoice'
  s.version = '0.2.0'
  s.summary = 'Ruby gem to use SUNAT Electronic Billing from your app'
  s.description = 'Generate and send Electronic Invoices to SUNAT'
  s.authors = ['César Carruitero']
  s.email = ['cesar@mozilla.pe']
  s.homepage = 'https://github.com/ccarruitero/sunat_invoice'
  s.license = 'MPL-2.0'

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'nokogiri', '~> 1.8'
  s.add_dependency 'rubyzip', '~> 1.2'
  s.add_dependency 'savon', '~> 2.11'
  s.add_dependency 'xmldsig', '~> 0.6.5'

  s.add_development_dependency 'cutest', '~> 1.2'
  s.add_development_dependency 'factory_bot', '~> 4.8'
  s.add_development_dependency 'ffaker', '~> 2.7'
  s.add_development_dependency 'pry', '~> 0.11'
  s.add_development_dependency 'rubocop', '~> 1.4'
end
