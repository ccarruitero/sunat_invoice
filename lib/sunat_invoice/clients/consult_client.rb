# frozen_string_literal: true

module SunatInvoice
  class ConsultClient < Client
    # consult CDR and ticket state

    def wsdl
      'https://www.sunat.gob.pe/ol-it-wsconscpegem/billConsultService?wsdl'
    end
  end
end
