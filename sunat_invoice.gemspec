# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name = 'sunat_invoice'
  s.version = '0.0.1'
  s.summary = 'SOAP client to use SUNAT Electronic Invoice API'
  s.description = s.summary
  s.authors = ['César Carruitero']
  s.email = ['cesar@mozilla.pe']
  s.homepage = 'https://github.com/ccarruitero/sunat_invoice'
  s.license = 'MPL-2.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'savon', '2.11.1'

  s.add_dependency 'gyoku', '1.3.1'
  s.add_dependency 'nokogiri', '~> 1.7'

  s.add_development_dependency 'cutest', '~> 1.2'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker', '~> 2.5'
  s.add_development_dependency 'pry', '~> 0.1'
  s.add_development_dependency 'rubocop', '~> 0.47'
end
