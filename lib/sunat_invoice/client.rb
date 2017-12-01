# frozen_string_literal: true

require 'zip'
require 'savon'

module SunatInvoice
  class Client
    def initialize(env = 'dev')
      bill_service_path = send("#{env}_server")
      @bill_service = Savon.client(wsdl: bill_service_path)
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

    def prepare_zip(invoice, name)
      # * invoice - xml document to zip
      # * name - xml document name
      zip = Zip::OutputStream::write_buffer do |zip|
        zip.put_next_entry name
        zip.write invoice
      end
      zip.rewind
      encode(zip.sysread)
    end

    def authenticate
      # TODO: authenticate with SUNAT
    end

    def close_client
      # TODO: to clean provider configuration and close sunat authentication
    end

    def send_invoice(invoice, name)
      prepare_zip invoice, name
    end

    private

    def encode(zip_str)
      Base64.encode64(zip_str)
    end
  end
end
