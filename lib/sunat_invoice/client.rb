# frozen_string_literal: true

require 'zip'
require 'savon'

module SunatInvoice
  class Client
    def initialize(env = 'dev')
      bill_service_path = send("#{env}_server")
      @bill_service = savon_client(bill_service_path)
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

    def close_client
      # TODO: to clean provider configuration and close sunat authentication
    end

    def send_invoice(invoice, name)
      zip = prepare_zip(invoice, name)
      @bill_service.call(:send_bill, message: {
        fileName: "#{name}.zip", contentFile: zip
      })
    end

    private

    def encode(zip_str)
      Base64.encode64(zip_str)
    end

    def config
      SunatInvoice.configuration
    end

    def authentication
      login = config.account_ruc + config.account_user
      password = config.account_password
      [login, password]
    end

    def savon_client(wsdl)
      Savon.client(wsdl: wsdl,
                   wsse_auth: authentication,
                   ssl_cert_file: cert_file,
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
