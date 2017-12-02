# frozen_string_literal: true

module SunatInvoice
  class ValidateClient < Client
    # verify invoice generated

    def wsdl
      'https://www.sunat.gob.pe/ol-it-wsconsvalidcpe/billValidService?wsdl'
    end

    def verify_file(invoice, name)
      cli = savon_client(valid_server)
      cli.call(:verifica_cp_earchivo, message: {
                 nombre: name, archivo: invoice
               })
    end
  end
end
