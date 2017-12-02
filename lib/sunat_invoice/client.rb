# frozen_string_literal: true

require 'zip'
require 'savon'

module SunatInvoice
  class Client
    def initialize(env = 'dev')
      @env = env
      @soap_client = savon_client
    end

    def log
      (@env != 'prod')
    end

    private

    def config
      SunatInvoice.configuration
    end

    def authentication
      login = config.account_ruc + config.account_user
      password = config.account_password
      [login, password]
    end

    def savon_client
      Savon.client(wsdl: wsdl,
                   wsse_auth: authentication,
                   namespace: 'http://service.sunat.gob.pe',
                   ssl_cert_file: cert_file,
                   log: log,
                   ssl_cert_key_file: pk_file)
    end

    def cert_file
      config.provider.cert_file
    end

    def pk_file
      config.provider.pk_file
    end
  end
end
