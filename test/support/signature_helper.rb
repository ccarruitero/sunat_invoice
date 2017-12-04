# frozen_string_literal: true

module SignatureHelper
  def self.generate_keys
    return if exists?('pk_file')

    pk = OpenSSL::PKey::RSA.new 2048
    cert = generate_certificate(pk)

    cert_dir = "#{File.dirname(__FILE__)}/../certs"
    Dir.mkdir(cert_dir) unless Dir.exist?(cert_dir)
    File.open(file('pk_file'), 'w') { |f| f.puts pk.to_pem }
    File.open(file('cert_file'), 'w') { |f| f.puts cert.to_pem }
  end

  def self.generate_certificate(pk)
    name = OpenSSL::X509::Name.parse('CN=example.com/C=EE')
    cert = OpenSSL::X509::Certificate.new
    cert.version    = 2
    cert.serial     = 0
    cert.not_before = Time.now
    cert.not_after  = cert.not_before + 1 * 365 * 24 * 60 * 60
    cert.public_key = pk.public_key
    cert.subject    = name
    cert.issuer     = name
    cert.sign pk, OpenSSL::Digest::SHA1.new
    cert
  end

  def self.file(name)
    File.join(File.dirname(__FILE__), "../certs/#{name}")
  end

  def self.exists?(name)
    File.exist?(file(name))
  end
end
