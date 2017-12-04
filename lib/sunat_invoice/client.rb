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
                   log: log)
    end
  end
end
