# frozen_string_literal: true

module SignatureHelper
  def self.generate_keys(keys_dir = "#{SunatInvoice.root}/test/certs")
    return if File.exist?("#{keys_dir}/pk_file")

    pk = OpenSSL::PKey::RSA.new 2048
    cert = generate_certificate(pk)

    Dir.mkdir(keys_dir) unless Dir.exist?(keys_dir)
    File.open("#{keys_dir}/pk_file", 'w') { |f| f.puts pk.to_pem }
    File.open("#{keys_dir}/cert_file", 'w') { |f| f.puts cert.to_pem }
  end

  def self.generate_certificate(pkey)
    name = OpenSSL::X509::Name.parse('CN=example.com/C=EE')
    cert = OpenSSL::X509::Certificate.new
    cert.version    = 2
    cert.serial     = 0
    cert.not_before = Time.now
    cert.not_after  = cert.not_before + 1 * 365 * 24 * 60 * 60
    cert.public_key = pkey.public_key
    cert.subject    = name
    cert.issuer     = name
    cert.sign pkey, OpenSSL::Digest::SHA1.new
    cert
  end
end
