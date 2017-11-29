# frozen_string_literal: true
require 'savon'
require 'gyoku'
require 'sunat_invoice/invoice'
require 'sunat_invoice/provider'
require 'sunat_invoice/customer'
require 'sunat_invoice/item'
require 'sunat_invoice/tax'

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
      'https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService?wsdl'
    end

    def dev_server
      'https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService?wsdl'
    end

    def consult_server
      # consult CDR and sended state
      'https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService?wsdl'
    end

    def valid_server
      # verify and validate invoice
      'https://www.sunat.gob.pe/ol-it-wsconsvalidcpe/billValidService?wsdl'
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
