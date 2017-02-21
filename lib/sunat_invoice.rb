# frozen_string_literal: true
require 'savon'
require 'gyoku'
require 'sunat_invoice/invoice'
require 'sunat_invoice/provider'
require 'sunat_invoice/customer'
require 'sunat_invoice/item'

module SunatInvoice
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :account_ruc, :account_user, :account_password,
                  :signature_path
  end

  class Client
    def initialize(env = 'dev')
      @bill_service_path = send("#{env}_server")
      @bill_service = Savon.client(wsdl: @bill_service_path)
      @consult_service = Savon.client(wsdl: consult_server)
    end

    def prod_server
      'https:// www.sunat.gob.pe/ol-ti-itcpfegem/billService'
    end

    def dev_server
      'https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService'
    end

    def consult_server
      'https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService'
    end

    def prepare_zip(invoice)
      # xml should be sended insided zip
      invoice.get_xml
      # TODO: wrap xml inside zip
    end

    def authenticate
      # TODO: authenticate with SUNAT
    end

    def close_client
      # TODO: to clean provider configuration and close sunat authentication
    end

    def send_invoice(invoice)
      prepare_zip invoice
    end
  end
end
