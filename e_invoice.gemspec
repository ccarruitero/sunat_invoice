Gem::Specification.new do |s|
  s.name = "e_invoice"
  s.version = "0.0.1"
  s.summary = "SOAP client to use SUNAT Electronic Invoice API"
  s.description = s.summary
  s.authors = ["César Carruitero"]
  s.email = ["cesar@mozilla.pe"]
  s.homepage = "https://github.com/ccarruitero/e_invoice"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency "savon", "2.6.0"

  s.add_development_dependency "cutest"
end
