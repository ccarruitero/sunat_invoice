# frozen_string_literal: true

module SunatInvoice
  class InvoiceClient < Client
    def wsdl
      send("#{@env}_server")
    end

    def prod_server
      'https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService?wsdl'
    end

    def dev_server
      'https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService?wsdl'
    end

    def prepare_zip(invoice, name)
      # * invoice - xml document to zip
      # * name - xml document name
      zip_file = Zip::OutputStream.write_buffer do |zip|
        zip.put_next_entry name
        zip.write invoice
      end
      zip_file.rewind
      encode(zip_file.sysread)
    end

    def send_invoice(invoice, name)
      zip = prepare_zip(invoice, name)
      @soap_client.call(:send_bill,
                        message: { fileName: "#{name}.zip", contentFile: zip })
    end

    private

    def encode(zip_str)
      Base64.encode64(zip_str)
    end
  end
end
