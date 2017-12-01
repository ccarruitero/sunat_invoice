module SignatureHelper
  def self.generate_keys
    pk = OpenSSL::PKey::RSA.new 2048
    name = OpenSSL::X509::Name.parse("CN=example.com/C=EE")
    cert = OpenSSL::X509::Certificate.new
    cert.version    = 2
    cert.serial     = 0
    cert.not_before = Time.now
    cert.not_after  = cert.not_before + 1 * 365 * 24 * 60 * 60
    cert.public_key = pk.public_key
    cert.subject    = name
    cert.issuer     = name
    cert.sign pk, OpenSSL::Digest::SHA1.new

    unless exists?('pk_file')
      cert_dir = "#{File.dirname(__FILE__)}/../certs"
      Dir.mkdir(cert_dir) unless Dir.exist?(cert_dir)
      File.open(file('pk_file'), 'w') { |f| f.puts pk.to_pem  }
      File.open(file('cert_file'), 'w') { |f| f.puts cert.to_pem  }
    end
  end

  def self.file(name)
    File.join(File.dirname(__FILE__), "../certs/#{name}")
  end

  def self.exists?(name)
    File.exists?(file(name))
  end
end
