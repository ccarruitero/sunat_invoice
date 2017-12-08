# frozen_string_literal: true

require_relative 'line'

module SunatInvoice
  class VoidedLine < Line
    attr_accessor :document_type, :document_serial, :document_number,
                  :description

    def xml(xml, index, _currency)
      xml['sac'].VoidedDocumentsLine do
        xml['cbc'].LineID(index + 1)
        xml['cbc'].DocumentTypeCode document_type
        xml['sac'].DocumentSerialID document_serial
        xml['sac'].DocumentNumberID document_number
        xml['sac'].VoidReasonDescription description
      end
    end
  end
end
