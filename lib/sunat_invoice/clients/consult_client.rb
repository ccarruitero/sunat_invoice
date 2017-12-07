# frozen_string_literal: true

module SunatInvoice
  class ConsultClient < Client
    # consult CDR and ticket state

    def wsdl
      'https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService?wsdl'
    end

    def get_status(ticket)
      @soap_client.call(:get_status, message: { ticket: ticket })
    end

    def get_status_cdr(options = {})
      # Available document_type to use:
      #   01: Factura.
      #   07: Nota de crédito.
      #   08: Nota de débito
      @soap_client.call(:get_status, message: {
                          rucComprobante: options[:ruc],
                          tipoComprobante: options[:document_type],
                          serieComprobante: options[:document_serial],
                          numeroComprobante: options[:document_number]
                       })
    end
  end
end
